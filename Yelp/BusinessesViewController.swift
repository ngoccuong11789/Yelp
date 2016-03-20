//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchResultsUpdating, UIScrollViewDelegate{

    var businesses: [Business]!
    var isMoreDataLoading = false
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UISearchBar: UITableView!
    var distance : Int?
    var filteredData: [Business] = []
    var addressArray = [String]()
    var endPoint: String!
    var prefs : NSUserDefaults!
    var selectedStates = [Int : Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefs = NSUserDefaults()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        
        Business.searchWithTerm("America", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                //print(business.name!)
                //print(business.address!)
                self.addressArray.append(business.address!)
            }
            
            
            
          //print(self.filteredData)
            self.filteredData = businesses
            
            
        })
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            
            return filteredData.count
        }
        else {
            if businesses != nil {
                return businesses!.count
            }else{
                return 0
            }
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        let business : Business
        if searchController.active && searchController.searchBar.text != "" {
            business = filteredData[indexPath.row]
        }else {
            business = businesses[indexPath.row]
        }
        
        
        cell.business = business
        //cell.business = filteredData[indexPath.row]
        
        return cell
    }
    
    
        
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    func filterContentForSearchText (searchText: String, scope: String = "All"){
        filteredData = businesses.filter { filter in
            
            return filter.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "FiltersViewController" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
            filtersViewController.switchStates = selectedStates
        } else {
            let detailViewController = segue.destinationViewController as! DetailViewController
            if searchController.active && searchController.searchBar.text != "" {
                let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell)
                //let selectedCell = addressArray[(selectedIndex?.row)!]
                let selectedCell = filteredData[(selectedIndex?.row)!].address!
                let nameCell = filteredData[(selectedIndex?.row)!].name!
                let distanceCell = filteredData[(selectedIndex?.row)!].distance!
                let reviewCell = filteredData[(selectedIndex?.row)!].reviewCount!
                let category = businesses[(selectedIndex?.row)!].categories!
                let imageThumb = filteredData[(selectedIndex?.row)!].imageURL!
                let imageRating = filteredData[(selectedIndex?.row)!].ratingImageURL!
                prefs.setObject(selectedCell, forKey: "country")
                prefs.setObject(nameCell, forKey: "name")
                prefs.setObject(distanceCell, forKey: "distance")
                prefs.setObject(reviewCell, forKey: "review")
                prefs.setObject(category, forKey: "category")
                prefs.setObject(imageThumb.absoluteString, forKey: "imageUrl")
                prefs.setObject(imageRating.absoluteString, forKey: "imageRating")
            }else {
            
            let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell)
            //let selectedCell = addressArray[(selectedIndex?.row)!]
            let selectedCell = businesses[(selectedIndex?.row)!].address!
            let nameCell = businesses[(selectedIndex?.row)!].name!
            let distanceCell = businesses[(selectedIndex?.row)!].distance!
            let reviewCell = businesses[(selectedIndex?.row)!].reviewCount!
            let category = businesses[(selectedIndex?.row)!].categories!
            let imageThumb = businesses[(selectedIndex?.row)!].imageURL!
            let imageRating = businesses[(selectedIndex?.row)!].ratingImageURL!
            prefs.setObject(selectedCell, forKey: "country")
            prefs.setObject(nameCell, forKey: "name")
            prefs.setObject(distanceCell, forKey: "distance")
            prefs.setObject(reviewCell, forKey: "review")
            prefs.setObject(category, forKey: "category")
            prefs.setObject(imageThumb.absoluteString, forKey: "imageUrl")
            prefs.setObject(imageRating.absoluteString, forKey: "imageRating")
            }
            //print(selectedCell)
            //print(nameCell)
        }
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject], selectedStates: [Int : Bool]) {
        self.selectedStates = selectedStates
        var categories = filters["categories"] as? [String]
        distance = filters["distance"] as? Int
        Business.searchWithTerm("Restaurants", sort: nil, distance: distance, categories: categories, deals: nil){(businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
        }
    }
    
    
    


}
