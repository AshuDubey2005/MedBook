//
//  LoginRepository.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation


enum LoginAndSignUpRepository {
    case fetchCountryList
    case fetchIPInformation
}

typealias ErrorMessage = (String?) -> Void

extension LoginAndSignUpRepository: HTTPRequestProtocol {
    var path: String {
        switch self {
        case .fetchCountryList:
            return ServiceUrlEndPoints.fetchCountries
        case .fetchIPInformation:
            return ServiceUrlEndPoints.fetchIPDetails
        }
    }
    
    var httpBody: Codable {
        switch self {
        case .fetchCountryList:
            return BaseEmptyModel()
        case .fetchIPInformation:
            return BaseEmptyModel()
        }
    }
    
    var queryParams: [String : String]? {
        nil
    }
}

extension LoginAndSignUpRepository {
    
    func fetchCountryListAPI(_ onResponse: @escaping ((CountryResponseModel?) -> Void),
                          _ onError: @escaping ErrorMessage) {
        let body = self.httpBody as? BaseEmptyModel
        Webservices.shared.getRequest(path: self.path, body: body) { (response: CountryResponseModel?, error) in
            if let getError = error?.serverMessage {
                onError(getError)
                return
                
            }
            onResponse(response)
        }
    }
    
    func fetchIPInformationAPI(_ onResponse: @escaping ((IPResponseModel?) -> Void),
                          _ onError: @escaping ErrorMessage) {
        let body = self.httpBody as? BaseEmptyModel
        Webservices.shared.getRequest(path: self.path, body: body) { (response: IPResponseModel?, error) in
            if let getError = error?.serverMessage {
                onError(getError)
                return
                
            }
            onResponse(response)
        }
    }
}
