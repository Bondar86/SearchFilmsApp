//
//  NetworkService.swift
//  SearchFilmsApp
//
//  Created by Иван Бондаренко on 18.09.2023.
//

import UIKit

final class NetworkService {
    
    // MARK: - Public method
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(searchTerm)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-API-KEY": "593b021d-1922-4e4b-83be-2f6c47e51074",
                                       "Content-Type": "application/json"]
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    // MARK: - Private method
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
