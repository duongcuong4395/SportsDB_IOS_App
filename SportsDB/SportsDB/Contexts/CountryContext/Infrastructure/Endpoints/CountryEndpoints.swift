//
//  CountryEndpoints.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Alamofire

enum CountryEndPoint<T: Decodable> {
    case GetCountries
}

extension CountryEndPoint: HttpRouter {
    typealias responseDataType = T
    
    var path: String {
        switch self {
        case .GetCountries:
            return "api/v1/json/3/all_countries.php"
        }
    }
    
    var menthod: Alamofire.HTTPMethod {
        .get
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
}

protocol CountryAPIExecution {}

extension CountryAPIExecution {
    func sendRequest<T: Decodable>(for api: CountryEndPoint<T>) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let request = APIRequest(router: api)
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
