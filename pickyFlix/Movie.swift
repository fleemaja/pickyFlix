//
//  Movie.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation
import UIKit

struct Movie {
    
    let id: Int32
    let title: String
    let year: String
    let rating: String
    let description: String
    let posterPath: String
    let posterImage: UIImage
    var savedMovie: Bool
    
    init(dictionary: [String : AnyObject], inWatchlist: Bool) {
        id = (dictionary["id"] as? Int32)!
        title = dictionary["title"] as? String ?? ""
        posterPath = "https://image.tmdb.org/t/p/w92\(dictionary["poster_path"] as! String)"
        year = dictionary["release_date"] as? String ?? ""
        rating = "\(dictionary["vote_average"]!)"
        description = dictionary["overview"] as? String ?? ""
        
        let url = URL(string: posterPath)
        let data = try? Data(contentsOf: url!)
        posterImage = UIImage(data: data!)!
        
        savedMovie = inWatchlist
    }
}
