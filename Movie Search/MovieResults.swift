//
//  File.swift
//  Movie Search
//
//  Created by Sedef Budak on 31/05/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation

class MovieResults: Codable {
    var totalPages = Int()
    var results = [Movie]()
    
    private enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results = "results"
    }
}

class Movie: Codable, CustomStringConvertible  {
    
    var title  = ""
    var popularity  = 0.0
    var vote  = 0.0
    var imagePath: String? = ""
    var overview = ""
    var releaseDate = ""
    var releaseDateV2: Date? {
        return myLocalDateFormatter.date(from: self.releaseDate)
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case popularity
        case overview
        case vote = "vote_average"
        case imagePath = "poster_path"
        case releaseDate = "release_date"
    }
    
    var description: String {
        return "title : \(title) and popularity: \(popularity)"
    }
}

func nameOrder (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}

func dateOrder(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.releaseDate >= rhs.releaseDate
}

func rateOrder(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.popularity >= rhs.popularity
}


