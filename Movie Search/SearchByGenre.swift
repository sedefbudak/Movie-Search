//
//  SearchByGenre.swift
//  Movie Search
//
//  Created by Sedef Budak on 07/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation
import UIKit

class SearchByGenre {
    
    var movieListbyGenre = [MovieByGenre]()
    var totalPages = Int()
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case resultsByGenre([MovieByGenre])
    }
    var state: State = .notSearchedYet
    private var dataTask: URLSessionDataTask? = nil
    
    private func moviesbyGenreUrl(selectedGenre: String, page: Int, sortingSelectedSegment: Int) -> URL {
        if sortingSelectedSegment == 0 {
            let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=962b77a3c4dfa95e0e12b1655fdb620a&language=en-US&sort_by=original_title.asc&include_adult=false&include_video=false&page=\(page)&with_genres=\(selectedGenre)"
            let url = URL(string: urlString)
            return url!
        } else {
            let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=962b77a3c4dfa95e0e12b1655fdb620a&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_genres=\(selectedGenre)"
            let url = URL(string: urlString)
            return url!
        }
    }
    
    private func parseForGenre(data: Data) -> [MovieByGenre] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(MovieResultsByGenre.self, from: data)
            totalPages = result.total_pages
            return result.results
        }
        catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func performSearchByGenre(selectedGenre: String, page: Int, selectedSegment: Int, completion: @escaping () -> ()) {
        dataTask?.cancel()
        state = .loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let url = moviesbyGenreUrl(selectedGenre: selectedGenre, page: page, sortingSelectedSegment: selectedSegment)
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: { data, response, error  in
            var newState = State.notSearchedYet
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                let results = self.parseForGenre(data: data)
                if results.isEmpty {
                    newState = .noResults
                } else {
                    if page == 1 {
                        self.movieListbyGenre.removeAll()
                        self.movieListbyGenre = results
                        newState = .resultsByGenre(self.movieListbyGenre)
                    } else {
                        self.movieListbyGenre += results
                        newState = .resultsByGenre(self.movieListbyGenre)
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





