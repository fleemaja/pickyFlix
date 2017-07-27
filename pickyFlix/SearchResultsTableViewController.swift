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
    
    var movies = [Movie]()
    
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
    
    var moviesFetched = false
    var castMemberFound = true
    
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
                } else {
                    self.castMemberFound = false
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        moviesFetched = false
        castMemberFound = true
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
        var numOfSections: Int = 0
        print("moviesFetched: \(moviesFetched)")
        print("movie count: \(movies.count)")
        print("cast member found: \(castMemberFound)")
        print("which thingy is it rendering? \(castMemberFound && (!moviesFetched || movies.count > 0))")
        if castMemberFound && (!moviesFetched || movies.count > 0) {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No results found"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
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
        print(options)
        TheMovieDatabaseApiClient.shared.getMovies(options: options) { [weak self] data, response, error in
            print("made api request")
            self?.moviesFetched = true
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
                for watchlistMovie in (self?.watchlist!)! {
                    if watchlistMovie.id == (result["id"] as! Int32) {
                        inWatchlist = true
                    }
                }
                let movie = Movie(dictionary: result, inWatchlist: inWatchlist)
                self?.movies.append(movie)
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }

}
