//
//  KeychainService.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation

enum UserDefaultKeys: String {
    case userCountry
    case isLogedIn
    case userEmail

}

extension UserDefaults {
    static var userCountry: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.userCountry.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userCountry.rawValue)
        }
    }

    static var isLogedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isLogedIn.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isLogedIn.rawValue)
        }
    }
    
    static var userEmail: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.userEmail.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userEmail.rawValue)
        }
    }
    
}
