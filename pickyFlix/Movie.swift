//
//  Movie.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

struct Movie {
    
    let id: Int32
    let title: String
    
    init(dictionary: [String : AnyObject]) {
        id = (dictionary["id"] as? Int32)!
        title = dictionary["title"] as? String ?? ""
    }
}
