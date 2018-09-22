//
//  DateFormatter.swift
//  Movie Search
//
//  Created by Sedef Budak on 06/06/2018.
//  Copyright © 2018 Sedef Budak. All rights reserved.
//

import Foundation

let myLocalDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
}()

//let myLocalDateFormatter: DateFormatter = DateFormatter()
