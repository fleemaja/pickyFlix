//
//  FiltersViewController.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/18/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var sortField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var startDateRange: UITextField!
    @IBOutlet weak var endDateRange: UITextField!
    
    let sortPicker = UIPickerView()
    let ratingPicker = UIPickerView()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    var sortPickerData: [String] = [String]()
    var ratingPickerData: [String] = [String]()
    
    var sortType = "popularity.desc"
    var rating = "All"
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 235/255, green: 120/255, blue: 108/255, alpha: 1.0)
        toolBar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        toolBar.setItems([flexBarButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sortPicker.delegate = self
        sortPicker.dataSource = self
        sortField.inputView = sortPicker
        
        ratingPicker.delegate = self
        ratingPicker.dataSource = self
        ratingField.inputView = ratingPicker
        
        sortField.inputAccessoryView = toolBar
        ratingField.inputAccessoryView = toolBar
        
        ratingPickerData = ["All",
            "G", "PG", "PG-13", "R", "NC-17"
        ]
        sortPickerData = ["popularity.desc", "revenue.desc", "release_date.desc", "vote_average.desc"]
        
        startDatePicker.datePickerMode = UIDatePickerMode.date
        startDateRange.inputView = startDatePicker
        startDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        endDatePicker.datePickerMode = UIDatePickerMode.date
        endDateRange.inputView = endDatePicker
        endDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        startDateRange.inputAccessoryView = toolBar
        endDateRange.inputAccessoryView = toolBar

    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        if sender == startDatePicker {
            startDateRange.text = dateFormatter.string(from: sender.date)
            startDate = sender.date
        } else {
            endDateRange.text = dateFormatter.string(from: sender.date)
            endDate = sender.date
        }
        
    }
    
    func donePicker(sender:UIBarButtonItem) {
        self.view.endEditing(true)
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
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                searchResultsViewController.startDate = dateFormatter.string(from: startDate!)
                searchResultsViewController.endDate = dateFormatter.string(from: endDate!)
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
            sortField.text = sortPickerData[row]
        } else if pickerView == ratingPicker {
            rating = ratingPickerData[row]
            ratingField.text = ratingPickerData[row]
        }
    }
}
