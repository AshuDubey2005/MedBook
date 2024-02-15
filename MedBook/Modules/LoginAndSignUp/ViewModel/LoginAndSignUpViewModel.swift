//
//  LoginAndSignUpViewModel.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation
import CoreData
import UIKit

class LoginAndSignUpViewModel: BaseViewModel {
    
    var isCountryFetchCompleted: Bindable<Bool> = Bindable(false)
    var isForLogin = false
    var countryList:[CountryData] = []
    var showLoader: Bindable<Bool> = Bindable(false)
    var usersCountry: String = ""
    var isValidPassword: Bindable<Bool> = Bindable(false)
    var isValidEmail: Bindable<Bool> = Bindable(false)
    var isCharCountCheck = false
    var isUpperCaseCheck = false
    var isSpecialCharCheck = false
    let dispatchGroup = DispatchGroup()
    
    init(isForLogin: Bool = false) {
        self.isForLogin = isForLogin
        super.init()
    }
    
    func loadCountries() {
        guard let countries = fetchCountriesFromCoreData(), !countries.isEmpty else {
            if !isForLogin {
                showLoader.value = true
                fetchCountyList()
                fetchIPDetails()
            }
            dispatchGroup.notify(queue: .main) {
                self.isCountryFetchCompleted.value = true
            }
            return
        }
        self.countryList = countries
        self.usersCountry = UserDefaults.userCountry
        DispatchQueue.main.async {
            self.isCountryFetchCompleted.value = true
        }
        
    }
    
    func validatePassword(_ password: String?) {
        guard let password = password else {
            return
        }
        // Check if at least 8 characters long
            isCharCountCheck = password.count < 8 ? false : true
        // Check if contains at least one uppercase letter
            isUpperCaseCheck = !password.contains(where: { $0.isUppercase }) ? false : true
        // Check if contains at least one special character
        let specialCharacterRegex = ".*[^A-Za-z0-9].*"
            isSpecialCharCheck = !(password.range(of: specialCharacterRegex, options: .regularExpression) != nil) ? false : true
        if isCharCountCheck, isUpperCaseCheck, isSpecialCharCheck {
            isValidPassword.value = true
        } else {
            isValidPassword.value = false
        }
    }
    
    func validateEmail(_ email: String?) {
           guard let email = email else {
               return
           }
           // Regular expression for basic email validation
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

           if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
               isValidEmail.value = true
           } else {
               isValidEmail.value = false
               
           }
       }
}


// MARK: API
extension LoginAndSignUpViewModel {
    func fetchCountyList() {
        dispatchGroup.enter()
        LoginAndSignUpRepository.fetchCountryList.fetchCountryListAPI({[weak self] response in
            if let countryData = response?.data {
               // self?.countryData = countryData
                self?.countryList = Array(countryData.values)
                self?.savePeopleToCoreData(countryList: self?.countryList ?? [])
            }
            self?.dispatchGroup.leave()
        }, { error in
            print(error ?? "")
            self.dispatchGroup.leave()
        })
    }
    
    func fetchIPDetails() {
        self.dispatchGroup.enter()
        LoginAndSignUpRepository.fetchIPInformation.fetchIPInformationAPI({[weak self] response in
            if let userCountry = response?.country {
                self?.usersCountry = userCountry
                UserDefaults.userCountry = userCountry
            }
            self?.dispatchGroup.leave()
        }, { error in
            print(error ?? "")
            self.dispatchGroup.leave()
        })
    }
    
}

// MARK: CoreData
extension LoginAndSignUpViewModel {
    
    func savePeopleToCoreData(countryList: [CountryData]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        for country in countryList {
            let entity = NSEntityDescription.entity(forEntityName: "CountryList", in: context)!
            let personManagedObject = NSManagedObject(entity: entity, insertInto: context) as! CountryList
            personManagedObject.country = country.country
            personManagedObject.region = country.region
        }

        do {
            try context.save()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    func fetchCountriesFromCoreData() -> [CountryData]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryList")

        do {
            if let fetchedResults = try context.fetch(fetchRequest) as? [CountryList] {
                let countries = fetchedResults.map { country in
                    return CountryData(country: country.country, region: country.region)
                }
                return countries
            } else {
                return nil
            }
            
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return []
        }
    }
}
