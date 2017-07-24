//
//  MovieTableViewCell.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/18/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit
import CoreData

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toggleWatchlistButton: UIButton!
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var movie: Movie? {
        didSet {
            updateUI()
        }
    }
    
    @IBAction func toggleWatchlistStatus(_ sender: UIButton) {
        var movieInfo = [String:Any]()
        movieInfo["id"] = movie?.id
        movieInfo["title"] = movie?.title
        if ((movie != nil) && (movie?.savedMovie)!) {
            movie?.savedMovie = false
            removeMovieFromWatchlist(with: movieInfo)
        } else {
            movie?.savedMovie = true
            addMovieToWatchlist(with: movieInfo)
        }
    }
    
    private func updateUI() {
        titleLabel?.text = movie?.title
        let movieYear = movie?.year
        yearLabel?.text = "🗓 \(movieYear?.substring(to: (movieYear?.index((movieYear?.startIndex)!, offsetBy: 4))!) ?? "")"
        
        let watchlistButtonLabel = (movie?.savedMovie)! ? "✓" : "+"
        toggleWatchlistButton?.setTitle(watchlistButtonLabel, for: .normal)
        
        descriptionLabel?.text = movie?.description
        ratingLabel?.text = "\(movie?.rating ?? "") ✭"
        
        if let image = movie?.posterImage {
            moviePoster?.image = image
        } else {
            moviePoster?.image = nil
        }
    }
    
    private func addMovieToWatchlist(with movieInfo: [String:Any]) {
        container?.performBackgroundTask { context in
            _ = try? MovieObject.findOrCreateMovie(matching: movieInfo, in: context)
            try? context.save()
        }
    }
    
    private func removeMovieFromWatchlist(with movieInfo: [String:Any]) {
        container?.performBackgroundTask { context in
            _ = try? MovieObject.removeMovie(matching: movieInfo, in: context)
            try? context.save()
        }
    }
    
    
}
