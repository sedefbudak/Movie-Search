//
//  SearchByGenre.swift
//  Movie Search
//
//  Created by Efe Budak on 07/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation
import UIKit

class SearchByGenre {
    
    var movieListbyGente = [MovieByGenre]()
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case resultsByGenre([MovieByGenre])
    }
    
    var state: State = .notSearchedYet
    
    private var dataTask: URLSessionDataTask? = nil
    
    private func moviesbyGenreUrl(selectedGenre: String, page: Int) -> URL {
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=962b77a3c4dfa95e0e12b1655fdb620a&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_genres=\(selectedGenre)"
        let url = URL(string: urlString)
        print("URL: \(url!)")
        return url!
    }
    
    private func parseForGenre(data: Data) -> [MovieByGenre] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(MovieResultsByGenre.self, from: data)
            return result.results
        }
        catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
   
    
    func performSearchByGenre(selectedGenre: String, page: Int,  completion: @escaping () -> ()) {
        
        dataTask?.cancel()
        state = .loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let url = moviesbyGenreUrl(selectedGenre: selectedGenre, page: page)
        
        let session = URLSession.shared
        
        dataTask = session.dataTask(with: url, completionHandler: { data, response, error  in
            var newState = State.notSearchedYet
            
            if (error as NSError?) != nil {
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                let results = self.parseForGenre(data: data)
                if results.isEmpty {
                    newState = .noResults
                } else {
                    self.movieListbyGente += results
                      /* if selectedSegment == 0 {
                     self.movieList.sort(by: nameOrder)
                     }
                     else {
                     self.movieList.sort(by: rateOrder)
                     }*/
                    newState = .resultsByGenre(self.movieListbyGente)
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





