//
//  Search.swift
//  Movie Search
//
//  Created by Efe Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation
import UIKit

class Search {
    
    var movieList = [Movie]()
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([Movie])
    }
    
    var state: State = .notSearchedYet
    
    private var dataTask: URLSessionDataTask? = nil
    
    private func movieUrl(searchKey: String) -> URL {
        let encodedText = searchKey.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=962b77a3c4dfa95e0e12b1655fdb620a&language=en-US&query=\(encodedText)&page=1&include_adult=false"
        
        let url = URL(string: urlString)
        print("URL: \(url!)")
        return url!
    }
    
    private func parse(data: Data) -> [Movie] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(MovieResults.self, from: data)
            return result.results
        }
        catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    
    
    func performSearch(text: String, selectedSegment: Int,  completion: @escaping () -> ()) {
        
        if !text.isEmpty {
            
            dataTask?.cancel()
            state = .loading
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            let url = movieUrl(searchKey: text)
            
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url, completionHandler: { data, response, error  in
                var newState = State.notSearchedYet
                
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    var results = self.parse(data: data)
                    
                    self.movieList = results
                    if results.isEmpty {
                        newState = .noResults
                    } else {
                        if selectedSegment == 0 {
                        results.sort(by: nameOrder)
                        }
                         else {
                            results.sort(by: rateOrder)
                        }
                        newState = .results(results)
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

