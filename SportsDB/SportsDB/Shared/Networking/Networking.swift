//
//  Networking.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Alamofire

enum APIResult<T> {
    case Successs(T)
    case Failure(Error)
}

enum APIError: Error {
    case DataFail
    case DecodingError
    case requestError(AFError)
}

protocol HttpRouter {
    associatedtype responseDataType: Decodable
    var baseURL: String { get }
    var path: String { get }
    var menthod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var body: Data? { get }
    
    func handleResponse(with data: Data?, error: AFError?) -> APIResult<responseDataType>
}

extension HttpRouter {
    func handleResponse(with data: Data?, error: AFError?) -> APIResult<responseDataType> {
        if let err = error {
            return .Failure(APIError.requestError(err))
        }
        
        guard let data = data else {
            return .Failure(APIError.DataFail)
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(responseDataType.self, from: data)
            return .Successs(result)
        } catch {
            print("=== json.error:", error.localizedDescription)
            return .Failure(APIError.DecodingError)
        }
    }
}

class APIRequest<Router: HttpRouter> {
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func callAPI(completion: @escaping (APIResult<Router.responseDataType>) -> Void) {
        var url = try? router.baseURL.asURL()
        url?.appendPathComponent(router.path)
        print("Enpoint: ", url ?? "", router.parameters as Any)
        AF.request(url ?? ""
                   , method: router.menthod
                   , parameters: router.parameters
                   , headers: router.headers
        ).responseData { response in
            let result = self.router.handleResponse(with: response.data, error: response.error)
            completion(result)
        }
    }
}


protocol APIExecution {}

extension APIExecution {
    func sendRequest<T: Decodable, R: HttpRouter>(for endpoint: R) async throws -> T where R.responseDataType == T {
        return try await withCheckedThrowingContinuation { continuation in
            let request = APIRequest(router: endpoint)
            request.callAPI { result in
                switch result {
                case .Successs(let data):
                    continuation.resume(returning: data)
                case .Failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
