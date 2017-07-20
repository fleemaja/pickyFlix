//
//  SearchResultsTableViewController.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/18/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchResults: String? {
        didSet {
            print("prepare for segue working as intended")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTMDBMovies()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        return cell
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
    
    func getTMDBMovies() {
        TheMovieDatabaseApiClient.shared.getMovies() { data, response, error in
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
                let movie = Movie(dictionary: result)
                self.movies.append(movie)
            }
            
//            for result in results {
//                DispatchQueue.global().async {
//                    let data = try? Data(contentsOf: url!)
//                    
//                    if data != nil {
//                        let image = UIImage(data: data!)
//                        var pinInfo = [String:Any]()
//                        pinInfo["latitude"] = self.latitudeVal
//                        pinInfo["longitude"] = self.longitudeVal
//                        self.addPhotoToDatabase(image: image!, pinInfo: pinInfo)
//                    }
//                }
//            }
        }
    }

}
