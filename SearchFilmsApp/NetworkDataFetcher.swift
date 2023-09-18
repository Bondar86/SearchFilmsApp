//
//  NetworkDataFetcher.swift
//  SearchFilmsApp
//
//  Created by Иван Бондаренко on 18.09.2023.
//

import Foundation

final class NetworkDataFetcher {
    
    // MARK: - Private properties
    
   private var networkService = NetworkService()
    
    // MARK: - Public methods
    
    func fetchImages(searchTerm: String, completion: @escaping (MovieResults?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: MovieResults.self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
