//
//  Movie.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

struct Movie {
    
    let title: String
    
    init(dictionary: [String : AnyObject]) {
        title = dictionary["title"] as? String ?? ""
    }
}
