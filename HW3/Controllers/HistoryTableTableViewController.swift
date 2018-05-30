//
//  HistoryTableTableViewController.swift
//  HW3
//
//  Created by Sneha Joshi on 5/29/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit

protocol HistoryTableTableViewControllerDelegate {
    func selectEntry(entry: LocationLookup)
}

class HistoryTableTableViewController: UITableViewController {
    
    var entries : [LocationLookup] = []

     var historyDelegate : HistoryTableTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
        
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for:
            indexPath)
        let location = self.entries[indexPath.row]
        cell.textLabel?.text = "(\((location.origLat*10000).rounded()/10000),\((location.origLng*10000).rounded()/10000)), (\((location.destLat*10000).rounded()/10000),\((location.destLng*10000).rounded()/10000))";
        cell.detailTextLabel?.text = "\(location.timestamp)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath){
        // use the historyDelegate to report back entry selected to the calculator
            if let del = self.historyDelegate {
            let ll = entries[indexPath.row]
            del.selectEntry(entry: ll)
        }
        // this pops to the calculator
        _ = self.navigationController?.popViewController(animated: true)
    }

}

