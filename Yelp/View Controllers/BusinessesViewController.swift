//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import ARSLineProgress

class BusinessesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    
    var businesses: [Business]!
    
    var filters = Filters.filterModel
    
    let metersConvert: Float = 1609.34
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // DYNAMIC HEIGHT
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // CREATE SEARCHBAR
        createSearchBar()
        
        tableView.tableFooterView = UIView()
        
        doSearch()
        
    }
    
    
    func doSearch () {
        
        var searchText: String? = filters.searchString
        if !(searchBar.text?.isEmpty)! {
            searchText = searchBar.text
            filters.searchString = searchBar.text!
        }
        
        ARSLineProgress.showWithPresentCompetionBlock {}
        var radius = 0 as Float
        let distanceValue = filters.distanceValue
        if distanceValue != 0 {
            radius = distanceValue * metersConvert
        }
        
        Business.search(with: searchText!, sort: YelpSortMode(rawValue: filters.sortByValue), categories: filters.categories, deals: filters.dealValue, radius: radius) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
                
                ARSLineProgress.hideWithCompletionBlock {}
            }
        }
//        Business.search(with: Filters.filterModel.searchString) { (businesses: [Business]?, error: Error?) in
//            if let businesses = businesses {
//                self.businesses = businesses
//                self.tableView.reloadData()
//                ARSLineProgress.hideWithCompletionBlock {}
//            }
//        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let filterVC = navController.topViewController as! FiltersViewController
        
        filterVC.delegate = self
    }

}

// TABLEVIEW
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        
        return cell
        
    }
    
}

// SEARCHBAR
extension BusinessesViewController: UISearchBarDelegate {
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Restaurant"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doSearch()
    }
    
}

// FILTER VIEW CONTROLLER

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filterViewControllerDidUpdate(_ filterViewController: FiltersViewController) {
        
        filters.dealValue = filterViewController.dealValue
        filters.categories = filterViewController.categoriesSearch
        filters.distanceValue = filterViewController.distanceValue
        filters.sortByValue = filterViewController.sortByValue
        
        doSearch()
    }
}

