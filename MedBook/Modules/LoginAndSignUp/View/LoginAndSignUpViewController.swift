//
//  LoginAndSignUpViewController.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import UIKit

class LoginAndSignUpViewController: BaseViewController<LoginAndSignUpViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblHeadingDesc: UILabel!
    @IBOutlet weak var btnLoginOrSignUp: UIButton!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var btnSpecialCharCheck: UIButton!
    @IBOutlet weak var btnUppcaseCheck: UIButton!
    @IBOutlet weak var btnCharLengthCheck: UIButton!
    @IBOutlet weak var viewPasswordValidations: UIStackView!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var viewInvalidEmailError: UIView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.loadCountries()
    }
    
    func setupView() {
        
        if viewModel.isForLogin {
            viewPasswordValidations.isHidden = true
            countryPicker.isHidden = true
            lblHeadingDesc.text = StringConstants.loginDescText
            btnLoginOrSignUp.setTitle(StringConstants.loginButtonText, for: .normal)
            viewLoader.stopAnimating()
        } else {
            viewPasswordValidations.isHidden = false
            countryPicker.isHidden = false
            lblHeadingDesc.text = StringConstants.signupDescText
            btnLoginOrSignUp.setTitle(StringConstants.signupButtonText, for: .normal)
        }
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        txtFieldPassword.delegate = self
        txtFieldEmail.delegate = self
    }
    
    // MARK: - Bindings
    override func addListener() {
        super.addListener()
        
        viewModel.isCountryFetchCompleted.bind { [weak self] _ in
            
            self?.countryPicker.reloadAllComponents()
            if let index = self?.viewModel.countryList.firstIndex(where: { $0.country == self?.viewModel.usersCountry }) {
                DispatchQueue.main.async {
                    self?.countryPicker.selectRow(index, inComponent: 0, animated: false)
                }
                
            }
            self?.viewLoader.stopAnimating()
        }
        
        viewModel.isValidPassword.bind { [weak self] isValidPassword in
            guard let self = self else { return }
            self.btnCharLengthCheck.isSelected = self.viewModel.isCharCountCheck
            self.btnUppcaseCheck.isSelected = self.viewModel.isUpperCaseCheck
            self.btnSpecialCharCheck.isSelected = self.viewModel.isSpecialCharCheck
        }
        
        viewModel.isValidEmail.bind { [weak self] isValidEmail in
            guard let self = self else { return }
            viewInvalidEmailError.isHidden = isValidEmail
        }
        
        viewModel.showLoader.bind { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.viewLoader.startAnimating()
            }
            
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func actionNavigate(_ sender: Any) {
        guard viewModel.isValidPassword.value , viewModel.isValidEmail.value  else {
            showAlert(title: "Alert", message: "Please enter a valid Email and Password", actionTitle: "OK")
            return
        }
        viewModel.isForLogin ? loginNavigation() : signupNavigation()
        
        
        
    }
    
    func signupNavigation() {
       
        if let email = txtFieldEmail.text, let password = txtFieldPassword.text {
            KeychainHelper.saveCredentials(username: email, password: password)
            UserDefaults.userEmail = email
        }
       
        UserDefaults.isLogedIn = true
        self.push(HomeViewController.getInstance(HomeViewModel()))
    }
    
    func loginNavigation() {
        if let email = txtFieldEmail.text, let enteredPassword = txtFieldPassword.text {
            if let password = KeychainHelper.retrievePassword(username: email), password == enteredPassword {
                UserDefaults.isLogedIn = true
                UserDefaults.userEmail = email
                self.push(HomeViewController.getInstance(HomeViewModel()))
            } else {
                showAlert(title: "Alert", message: "Please enter valid credentials", actionTitle: "OK")
            }
            
        }
       
    }
    
}

// MARK: - Extension UIPicker View
extension LoginAndSignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.countryList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return viewModel.countryList[row].country
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(viewModel.countryList[row].country ?? "")
    }
}

// MARK: - Extensions
extension LoginAndSignUpViewController {
    static func getInstance(_ instance: LoginAndSignUpViewModel) -> LoginAndSignUpViewController {
        let controller: LoginAndSignUpViewController = UIViewController.load()
        controller.viewModel = instance
        return controller
    }
}

// MARK: - Text Field Delegates
extension LoginAndSignUpViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtFieldPassword {
            viewModel.validatePassword(txtFieldPassword.text)
        }
        
        if textField == txtFieldEmail {
            viewModel.validateEmail(txtFieldEmail.text)
        }
    }
}
