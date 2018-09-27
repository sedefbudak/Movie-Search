//
//  Search.swift
//  Movie Search
//
//  Created by Sedef Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation
import UIKit

class Search {
    
    var movieList = [Movie]()
    var totalPages = Int()
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([Movie])
    }
    
    var state: State = .notSearchedYet
    
    private var dataTask: URLSessionDataTask? = nil
    
    private func createMovieUrl(searchKey: String, page: Int) -> URL {
        let encodedText = searchKey.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=962b77a3c4dfa95e0e12b1655fdb620a&language=en-US&query=\(encodedText)&page=\(page)&include_adult=false"
        let url = URL(string: urlString)
        return url!
    }
    
    private func parse(data: Data) -> [Movie] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(MovieResults.self, from: data)
            totalPages = result.totalPages
            return result.results
        }
        catch {
            print("JSON Error: \(error)")
            return []
        }
    }
        
    func performSearch(text: String, page: Int,  completion: @escaping () -> ()) {
        
        if !text.isEmpty {
            
            dataTask?.cancel()
            state = .loading
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let url = createMovieUrl(searchKey: text, page: page)
            
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url, completionHandler: { data, response, error  in
                var newState = State.notSearchedYet
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    let results = self.parse(data: data)
                    if results.isEmpty {
                        newState = .noResults
                    } else {
                        if page == 1 {
                            self.movieList.removeAll()
                            self.movieList = results
                            newState = .results(self.movieList)
                        } else {
                            self.movieList += results
                            newState = .results(self.movieList)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.state = newState
                    completion()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
            dataTask?.resume()
        }
    }
    
        
}


