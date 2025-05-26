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
