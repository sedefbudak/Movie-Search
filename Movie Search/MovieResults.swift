//
//  File.swift
//  Movie Search
//
//  Created by Efe Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation

class MovieResults: Codable {
    var results = [Movie]()
}

class Movie: Codable, CustomStringConvertible  {
    
    var title  = ""
    var popularity  = 0.0
    var vote  = 0.0
    var imagePath: String? = ""
    var overview = ""
    var year = ""
    

    private enum CodingKeys: String, CodingKey {
        case title
        case popularity
        case overview
        case vote = "vote_average"
        case imagePath = "poster_path"
        case year = "release_date"
        
    }
    
    var description: String {
        return "title : \(title) and popularity: \(popularity)"
    }
}

func < (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}

