//
//  LoginAndSignUpModel.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation

struct CountryResponseModel: Codable {
    let status: String?
    let statusCode: Int?
    let version, access: String?
    let data: [String: CountryData]?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version, access, data
    }
}

// MARK: - CountryData
struct CountryData: Codable {
    let country: String?
    let region: String?
}

struct IPResponseModel: Codable {
    let country: String?
    let countryCode: String?
}

