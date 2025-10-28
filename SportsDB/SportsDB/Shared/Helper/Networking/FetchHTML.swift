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

func fetchHTML(from urlString: String) async throws -> String {
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")

    let (data, _) = try await URLSession.shared.data(for: request)

    guard let html = String(data: data, encoding: .utf8) else {
        throw URLError(.cannotDecodeContentData)
    }

    return html
}

func getHTML(of htmlContent: String, from domBegin: String, to domEnd: String) -> String {
    guard let rangeTeamMembers = htmlContent.range(of: domBegin),
          let rangeFanart = htmlContent.range(of: domEnd) else { return "" }
    
    let htmlContentBetween = htmlContent[rangeTeamMembers.upperBound..<rangeFanart.lowerBound]
    let resultString = String(htmlContentBetween)
    
    return resultString
}
