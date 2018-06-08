//
//  Genre.swift
//  Movie Search
//
//  Created by Efe Budak on 06/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation

class GenreResults: Codable {
    
    var genres = [Genre]()
}

class Genre: Codable, CustomStringConvertible {
    
    var id = 0
    var name = ""
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var description: String {
        return "name: \(name) and id : \(id)"
    }

}




