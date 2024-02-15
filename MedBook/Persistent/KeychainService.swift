//
//  KeychainService.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation
import Security

class KeychainHelper {
    static let serviceIdentifier = NSString(format: kSecAttrService)
    
    static func saveCredentials(username: String, password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error saving credentials to Keychain: \(status)")
            return
        }
    }

    static func retrievePassword(username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data else {
            print("Error retrieving password from Keychain: \(status)")
            return nil
        }

        return String(data: retrievedData, encoding: .utf8)
    }
}
