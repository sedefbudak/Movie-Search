//
//  SearchGenre.swift
//  Movie Search
//
//  Created by Sedef Budak on 06/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation

class SearchGenre {
    
    var genres = [Genre]()
    
    private var dataTask: URLSessionDataTask? = nil

    
    func parse(data: Data) -> [Genre] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(GenreResults.self, from: data)
            return result.genres
        }
        catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func getGenre(completion: @escaping () -> ()) {
        
        dataTask?.cancel()
        
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=962b77a3c4dfa95e0e12b1655fdb620a&language=en-US"
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        dataTask = session.dataTask(with: url!, completionHandler: { data, response, error  in
            
            if let error = error as NSError? {
                return
            }
            
            if let _ = response as? HTTPURLResponse, let data = data {
                let results = self.parse(data: data)
                if results.isEmpty {
                } else {
                self.genres = results
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        })
        dataTask?.resume()
    }
}
