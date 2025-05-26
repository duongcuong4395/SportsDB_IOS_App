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
            print("Decoding", error)
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
            //print("Enpoint.response:", response.response?.statusCode)
            let result = self.router.handleResponse(with: response.data, error: response.error)
            completion(result)
        }
    }
}
