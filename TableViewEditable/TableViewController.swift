//
//  TableViewController.swift
//  TableViewEditable
//
//  Created by Nikhil Patil on 24/02/19.
//  Copyright © 2019 Nikhil Patil. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UISearchResultsUpdating {
    
    
    @IBOutlet weak var AddCellBtn: UIBarButtonItem!
    
    var dataArray = ["Audi","BMW","Land Rover","Mercedes Benz","Jaguar","Bentley","Toyota","Mahindra","Ferrari","Lamborghini","Amitabh Bachchan","Rajinikanth","Dulquer Salmaan","Robert Downey Jr.","Mahesh Babu","Salman Khan","Ranveer Singh","Ranbir Kapoor","Mohanlal","Sushant Singh","Sachin Tendulkar","MS Dhoni","Virat Kohli","Faf du Plessis","Kane willianson","David Warner","Ben Stokes","Lasith Malinga","Jasprit Bumrah","Rashid Khan","Kuldeep Yadav","Ravindra Jadeja"]
    
    var searchControllerObj = UISearchController(searchResultsController: nil)
    
    var filteredArray :[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchControllerObj.searchResultsUpdater = self
        searchControllerObj.searchBar.placeholder = "Search From Below Details"
        searchControllerObj.searchBar.showsCancelButton = true
        searchControllerObj.searchBar.showsBookmarkButton = true
        searchControllerObj.searchBar.scopeButtonTitles = ["A","B","C"]
//        searchControllerObj.searchBar.showsScopeBar = true
//        searchControllerObj.searchBar.prompt = "Just Searching"
        tableView.tableHeaderView = searchControllerObj.searchBar
     
        // For Refreshing Animation
        refreshControl = UIRefreshControl()
        
        refreshControl?.addTarget(self, action: #selector(onRefreshControl), for: UIControl.Event.valueChanged)
    }
    // For Animation Control of RefreshController
    @objc func onRefreshControl()
    {
        refreshControl?.endRefreshing()
    }
    
    //Update Search Result
    func updateSearchResults(for searchController: UISearchController) {
        
        
        let predicate = NSPredicate(format: "SELF Contains[c] %@", searchController.searchBar.text!)
        
        filteredArray = (dataArray as NSArray).filtered(using: predicate) as! [String]
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchControllerObj.isActive == true)
        {
            return filteredArray.count
        }else
        {
            return dataArray.count
        }
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Data", for: indexPath)

        if(searchControllerObj.isActive == true)
        {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }else
        {
            cell.textLabel!.text = dataArray[indexPath.row]
        }
        // Configure the cell...

        return cell
    }
   

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("Person Name Moved From \(sourceIndexPath.row) to \(destinationIndexPath.row)")
        
        print(dataArray)
        
        let movedPersonName = dataArray[sourceIndexPath.row]
        dataArray.remove(at: sourceIndexPath.row)
        dataArray.insert(movedPersonName, at: destinationIndexPath.row)
        
        print(dataArray)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            
            print(dataArray)
            
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            print(dataArray)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func AddCellBtn(_ sender: Any) {
        addNames()
    }
    
    func addNames()
    {
        let alert = UIAlertController(title: "New Person Name", message: "Add Person Name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Add Name Here...."
        }
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert](_) in
            
            let text = alert?.textFields![0]
            
            print(self.dataArray)
            self.dataArray.append((text?.text)!)
            self.tableView.reloadData()
            
            print(self.dataArray)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }


}
