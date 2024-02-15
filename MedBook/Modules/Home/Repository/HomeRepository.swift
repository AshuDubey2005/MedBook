//
//  HomeRepository.swift
//  MedBook
//
//  Created by deq on 15/02/24.
//

import Foundation

enum HomeRepository {
    case searchBooks
}

extension HomeRepository: HTTPRequestProtocol {
    var path: String {
        switch self {
        case .searchBooks:
            return ServiceUrlEndPoints.searchBook
        }
    }
    
    var httpBody: Codable {
        switch self {
        case .searchBooks:
            return BaseEmptyModel()
        }
    }
    
    var queryParams: [String : String]? {
        nil
    }
}

extension HomeRepository {
    
    func searchBooksAPI(title: String, offset: Int, limit: Int,_ onResponse: @escaping ((SearchedBooksResponse?) -> Void),
                          _ onError: @escaping ErrorMessage) {
            let baseURL = self.path
            var urlComponents = URLComponents(string: baseURL)
            urlComponents?.queryItems = [
                URLQueryItem(name: "title", value: title),
                URLQueryItem(name: "offset", value: String(offset)),
                URLQueryItem(name: "limit", value: String(limit))
            ]

        guard let finalURL = urlComponents?.url?.absoluteString else {
                print("Error creating final URL")
                return
            }
        
        let body = self.httpBody as? BaseEmptyModel
        Webservices.shared.getRequest(path: finalURL, body: body) { (response: SearchedBooksResponse?, error) in
            if let getError = error?.serverMessage {
                onError(getError)
                return
                
            }
            onResponse(response)
        }
    }
}
