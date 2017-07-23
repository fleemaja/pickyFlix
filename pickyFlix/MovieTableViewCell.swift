//
//  MovieTableViewCell.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/18/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        titleLabel?.text = movie?.title
        let movieYear = movie?.year
        if (movieYear?.characters.count)! >= 4 {
            yearLabel?.text = movieYear?.substring(to: (movieYear?.index((movieYear?.startIndex)!, offsetBy: 4))!)
        } else {
            yearLabel?.text = ""
        }
        
        descriptionLabel?.text = movie?.description
        ratingLabel?.text = "\(movie?.rating ?? "") ✭"
        
        if let image = movie?.posterImage {
            moviePoster?.image = image
        } else {
            moviePoster?.image = nil
        }
    }
    
    
}
