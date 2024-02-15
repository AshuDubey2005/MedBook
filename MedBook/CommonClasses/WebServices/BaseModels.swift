//
//  KeychainService.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation

class BaseModel: Codable {}

struct ErrorModel: Error {
    var customErrorCode: Int?
    var serverMessage: String?
    var completeData: Data?
    
    init(customErrorCode: Int?, serverMessage: String?, response: Data?) {
        self.customErrorCode = customErrorCode
        self.serverMessage = serverMessage
        self.completeData = response
    }
}

class BaseEmptyModel: Codable {}
