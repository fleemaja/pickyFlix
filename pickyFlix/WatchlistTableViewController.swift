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
    
    var movies = [MovieObject]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadMovies()
    }
    
    private func loadMovies() {
        print("loading movies")
        self.movies.removeAll()
        if let context = container?.viewContext {
            context.perform {
                let movieRequest: NSFetchRequest<MovieObject> = MovieObject.fetchRequest()
                if let movieObjects = (try? context.fetch(movieRequest)) {
                    print("MovieObject count: \(movieObjects.count)")
                    for movie in movieObjects {
                        self.movies.append(movie)
                    }
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
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = "ON WATCHLIST"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

}
