//
//  MovieResultsByGenre.swift
//  Movie Search
//
//  Created by Sedef Budak on 07/06/2018.
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
    var releaseDate = ""
    var releaseDateV2: Date? {
        return myLocalDateFormatter.date(from: self.releaseDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case popularity
        case overview
        case imagePath = "poster_path"
        case releaseDate = "release_date"

    }
    
    var description: String {
        return "title : \(title) and popularity: \(popularity)"
    }
}

func nameOrder (lhs: MovieByGenre, rhs: MovieByGenre) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}

func dateOrder(lhs: MovieByGenre, rhs: MovieByGenre) -> Bool {
    return lhs.releaseDate >= rhs.releaseDate
}

func rateOrder(lhs: MovieByGenre, rhs: MovieByGenre) -> Bool {
    return lhs.popularity >= rhs.popularity
}


