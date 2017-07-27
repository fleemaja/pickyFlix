//
//  SearchResultsTableViewController.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/18/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsTableViewController: UITableViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var watchlist: [MovieObject]? {
        didSet {
            getTMDBMovies(options: options)
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var options = [String : Any]()
    
    var sortType: String?
    var rating: String?
    var startDate: String?
    var endDate: String?
    var genre: String?
    
    var page = 1
    
    var castMember: String?
    var castMemberId: String? {
        didSet {
            setOptions()
        }
    }
    
    private func getCastMemberId(castMember: String) {
        print("getting cast member id")
        if castMember == "" {
            castMemberId = ""
            self.movies.removeAll()
            self.loadWatchlist()
        } else {
            TheMovieDatabaseApiClient.shared.getCastMemberId(castMember: castMember) { data, response, error in
                if error != nil {
                    print(error ?? "There was an error")
                    return
                }
                
                let results: [[String: AnyObject]]
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    results = (json?["results"] as? [[String : AnyObject]])!
                } catch {
                    print("JSON converting error")
                    return
                }
                
                if results.count > 0 {
                    self.castMemberId = String(describing: results[0]["id"]!)
                    print("loading watchlist")
                    DispatchQueue.main.async {
                        self.movies.removeAll()
                        self.loadWatchlist()
                    }
                }
            }
        }
    }
    
    private func setOptions() {
        options["sortType"] = sortType!
        options["rating"] = rating!
        options["page"] = page
        options["rating"] = rating!
        options["startDate"] = startDate!
        options["endDate"] = endDate!
        options["genre"] = genre!
        options["castMemberId"] = castMemberId!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        page = 1
        options["page"] = page
        getCastMemberId(castMember: castMember!)
    }
    
    private func loadWatchlist() {
        if let context = container?.viewContext {
            context.perform {
                let movieRequest: NSFetchRequest<MovieObject> = MovieObject.fetchRequest()
                if let movieObjects = (try? context.fetch(movieRequest)) {
                    self.watchlist = movieObjects
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        // Configure the cell...
        let movie = movies[indexPath.row]
        if let movieCell = cell as? MovieTableViewCell {
            movieCell.movie = movie
        }
        
        // if last table cell is rendered fetch next page of api request results
        if (indexPath.row == movies.count - 1) {
            page += 1
            options["page"] = page
            getTMDBMovies(options: options)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let url =  URL(string: "https://www.themoviedb.org/movie/\(movie.id)")!
        UIApplication.shared.open(url, options: [:])
    }
    
    func getTMDBMovies(options: [String : Any]) {
        spinner.startAnimating()
        TheMovieDatabaseApiClient.shared.getMovies(options: options) { data, response, error in
            if error != nil {
                return
            }
            
            let results: [[String: AnyObject]]
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                results = (json?["results"] as? [[String : AnyObject]])!
            } catch {
                print("JSON converting error")
                return
            }
            
            print("adding movies")
            for result in results {
                var inWatchlist = false
                for watchlistMovie in self.watchlist! {
                    if watchlistMovie.id == (result["id"] as! Int32) {
                        inWatchlist = true
                    }
                }
                let movie = Movie(dictionary: result, inWatchlist: inWatchlist)
                self.movies.append(movie)
            }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
    }

}
