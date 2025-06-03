//
//  FetchHTML.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import Foundation

func fetchHTML(from urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(URLError(.badURL)))
        return
    }

    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data,
              let html = String(data: data, encoding: .utf8) else {
            completion(.failure(URLError(.cannotDecodeContentData)))
            return
        }

        completion(.success(html))
    }.resume()
}
