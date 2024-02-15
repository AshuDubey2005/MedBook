//
//  KeychainService.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import UIKit
import Alamofire

class Webservices: NSObject {
    
    public static var shared = Webservices()
    private var sessionManager: Session!
    private var timeoutInterval = 130
    
    override private init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeoutInterval)
        configuration.timeoutIntervalForResource = TimeInterval(timeoutInterval)
        sessionManager = Session(configuration: configuration)
    }
    
    
    func postRequest<T: ResponseModelProtocol, U: Codable>(isShowLoader: Bool? = true, path: String, body: U, completion: @escaping(_ apiResponse: T?, _ error: ErrorModel?) -> Void) {
        
        let url =  path
        
        let req = APIRequest<T>(url: url, requestBody: body)
        
        if Constants.isLoggerOn {
            print("Raw Data:-" + String(decoding: req.body ?? Data(), as: UTF8.self) + ", url :- \(url)" )
        }
        
        performRequest(isShowLoader: isShowLoader, request: req) { (result, _) in
            
            switch result {
            case .success(let data):
                completion(data.self, nil )
            case .failure(let err):
                completion(nil, err)
                
            }
        }
    }
    
    
    func getRequest<T: Codable, U: Codable>(isShowLoader: Bool? = true, path: String, body: U, completion: @escaping(_ apiResponse: T?, _ error: ErrorModel?) -> Void) {
        
        var  req = APIRequest<T>(url: path)
        req.httpMethod = .get
        
        performRequest(isShowLoader: isShowLoader, request: req) { (result, _) in
            
            switch result {
            case .success(let data):
                completion(data.self, nil)
            case .failure(let err):
                completion(nil, err)
            }
        }
        
    }
    
    func performRequest<T>(isShowLoader: Bool?, request: APIRequest<T>, completion: @escaping (Swift.Result<T, ErrorModel>, String?) -> Void) {
        
        let url: URL = request.url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.body
        
        sessionManager.request(urlRequest).responseData { (response) in
            self.parseResponse(isShowLoader: isShowLoader, response: response, url: request.url.absoluteString, completion: completion)
        }
    }
    
    func parseResponse<T: Codable>(isShowLoader: Bool?, response: AFDataResponse<Data>, url: String, completion: @escaping (Swift.Result<T, ErrorModel>, String?) -> Void ) {
        
        if case .success( _) = response.result {
            if let responseData = response.data {
                do {
                    
                    let responseObj = try JSONDecoder().decode(T.self, from: responseData)
                    
                    
                    completion(.success(responseObj), "Success")
                    
                    
                } catch let error {
                    if Constants.isLoggerOn {
                        print(error)
                    }
                    let message = "Something went wrong, please try again after some time."
                    let errorModel = ErrorModel(customErrorCode: 404, serverMessage: message, response: nil)
                    completion(.failure(errorModel), message)
                }
            } else {
                let message = "Error!!! response.data is Empty"
                let errorModel = ErrorModel(customErrorCode: 404, serverMessage: message, response: nil)
                completion(.failure(errorModel), message)
            }
        } else {
            let message = "Unable to process your request due to connection timeout. Please try again after sometime."
            let errorModel = ErrorModel(customErrorCode: 404, serverMessage: message, response: nil)
            completion(.failure(errorModel), message)
        }
    }
    
}
