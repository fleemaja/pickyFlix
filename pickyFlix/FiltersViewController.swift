//
//  FiltersViewController.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/18/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    var sortPickerData: [String] = [String]()
    @IBOutlet weak var sortPicker: UIPickerView!
    
    var ratingPickerData: [String] = [String]()
    @IBOutlet weak var ratingPicker: UIPickerView!
    
    var sortType = "popularity.desc"
    var rating = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sortPicker.delegate = self
        self.sortPicker.dataSource = self
        self.ratingPicker.delegate = self
        self.ratingPicker.dataSource = self
        
        ratingPickerData = ["All",
            "G", "PG", "PG-13", "R", "NC-17"
        ]
        sortPickerData = ["popularity.desc", "revenue.desc", "release_date.desc", "vote_average.desc"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // make api request and render table of results in detail view
        // segue identifier: filterMovies
        let tabBarController = segue.destination as! UITabBarController
        if let navigationController = tabBarController.viewControllers?[0] as? UINavigationController,
           let searchResultsViewController = navigationController.visibleViewController as? SearchResultsTableViewController,
           let identifier = segue.identifier {
            if identifier == "filterMovies" {
                searchResultsViewController.sortType = sortType
                searchResultsViewController.rating = rating
            }
        }
    }


}

extension FiltersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sortPicker:
            return sortPickerData.count
        case ratingPicker:
            return ratingPickerData.count
        default:
            return 1
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sortPicker:
            return sortPickerData[row]
        case ratingPicker:
            return ratingPickerData[row]
        default:
            return "Error"
        }
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        if pickerView == sortPicker {
            sortType = sortPickerData[row]
        } else if pickerView == ratingPicker {
            rating = ratingPickerData[row]
        }
    }
}
