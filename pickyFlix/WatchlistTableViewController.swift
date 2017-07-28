//
//  WatchlistTableViewController.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit
import CoreData

class WatchlistTableViewController: UITableViewController {
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // estimated height is the height of poster images returned from TMDB API
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadMovies()
    }
    
    private func loadMovies() {
        movies.removeAll()
        if let context = container?.viewContext {
            context.perform {
                let movieRequest: NSFetchRequest<MovieObject> = MovieObject.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
                movieRequest.sortDescriptors = [sortDescriptor]
                if let movieObjects = (try? context.fetch(movieRequest)) {
                    for movie in movieObjects {
                        self.createMovieFromMovieObject(movie: movie)
                    }
                }
            }
        }
    }
    
    private func createMovieFromMovieObject(movie: MovieObject) {
        var movieDictionary = [String : AnyObject]()
        movieDictionary["id"] = movie.id as AnyObject
        movieDictionary["title"] = movie.title as AnyObject
        movieDictionary["release_date"] = movie.year as AnyObject
        movieDictionary["posterImage"] = movie.posterImage
        movieDictionary["overview"] = movie.overview as AnyObject
        movieDictionary["vote_average"] = movie.rating as AnyObject
        let movie = Movie(dictionary: movieDictionary, inWatchlist: true)
        movies.append(movie)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if (movies.count > 0) {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Your watchlist is empty"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        // Configure the cell...
        let movie = movies[indexPath.row]
        if let movieCell = cell as? MovieTableViewCell {
            movieCell.movie = movie
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let url =  URL(string: "https://www.themoviedb.org/movie/\(movie.id)")!
        UIApplication.shared.open(url, options: [:])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let movie = movies[indexPath.row]
            if let context = container?.viewContext {
                context.perform {
                    let movieRequest: NSFetchRequest<MovieObject> = MovieObject.fetchRequest()
                    movieRequest.predicate = NSPredicate(format: "%K == %@", argumentArray:["id", movie.id])
                    if let result = try? context.fetch(movieRequest) {
                        for object in result {
                            context.delete(object)
                            self.movies.remove(at: indexPath.row)
                        }
                        try? context.save()
                    }
                }
            }
        }
    }

}
