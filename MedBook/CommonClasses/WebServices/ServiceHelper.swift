
import Foundation
import Alamofire

protocol ResponseModelProtocol: Codable {
    var status: String { get set }
    var responseCode: Int { get set }
    var message: String? { get set }
}

struct APIRequest<T: Codable> {
    let url: URL
    var httpMethod: HTTPMethod = .get
    var body: Data?
    var loginBody: Dictionary<String, Any>?
    var checksumParam: Dictionary<String, Any>?
    var paramaterEncoding: ParameterEncoding = JSONEncoding.default
    
    init(url: String) {
        let percentEncodedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.url = Foundation.URL(string: percentEncodedURLString!)!
    }
    
    init<U: Codable>(url: String, requestBody: U? = nil) {
        let percentEncodedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.url = Foundation.URL(string: percentEncodedURLString!)!
        httpMethod = .post
        body = try? JSONEncoder().encode(requestBody)
    }
}
