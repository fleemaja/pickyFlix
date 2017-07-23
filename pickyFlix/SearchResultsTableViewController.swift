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
    
    var page = 1
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var watchlist = [MovieObject]() {
        didSet {
            getTMDBMovies(page: page)
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var searchResults: String? {
        didSet {
            print("prepare for segue working as intended")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWatchlist()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            getTMDBMovies(page: page)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movie = movies[indexPath.row]
        movies.remove(at: indexPath.row)
        movie.savedMovie = true
        movies.insert(movie, at: indexPath.row)
        var movieInfo = [String:Any]()
        movieInfo["id"] = movie.id
        movieInfo["title"] = movie.title
        addMovieToWatchlist(with: movieInfo)
    }
    
    private func addMovieToWatchlist(with movieInfo: [String:Any]) {
        print("adding \(String(describing: movieInfo["title"])) to watchlist")
        container?.performBackgroundTask { context in
            _ = try? MovieObject.findOrCreateMovie(matching: movieInfo, in: context)
            try? context.save()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getTMDBMovies(page: Int) {
        spinner.startAnimating()
        TheMovieDatabaseApiClient.shared.getMovies(page: page) { data, response, error in
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
            
            for result in results {
                var inWatchlist = false
                for watchlistMovie in self.watchlist {
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
