//
//  KeychainService.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation

extension Data {
    
    var dict: [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? [String: Any]
    }
}
