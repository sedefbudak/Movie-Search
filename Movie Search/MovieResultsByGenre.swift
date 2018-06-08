//
//  MovieResultsByGenre.swift
//  Movie Search
//
//  Created by Efe Budak on 07/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation

class MovieResultsByGenre: Codable {
    
    var page : Int!
    var total_results: Int!
    var total_pages : Int!
    var results = [MovieByGenre]()
    
}

class MovieByGenre: Codable, CustomStringConvertible {
    
    var title  = ""
    var popularity  = 0.0
    var overview = ""
    var imagePath: String? = ""
    
    private enum CodingKeys: String, CodingKey {
        case title
        case popularity
        case overview
        case imagePath = "poster_path"
    }
    
    var description: String {
        return "title : \(title) and popularity: \(popularity)"
    }
}



