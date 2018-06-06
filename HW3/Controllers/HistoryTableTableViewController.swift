//
//  HistoryTableTableViewController.swift
//  HW3
//
//  Created by Sneha Joshi and Akshay on 5/29/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit

protocol HistoryTableTableViewControllerDelegate {
    func selectEntry(entry: LocationLookup)
}

class HistoryTableTableViewController: UITableViewController {
    
    var entries : [LocationLookup] = []

    var historyDelegate : HistoryTableTableViewControllerDelegate?
    
    var tableViewData: [(sectionHeader: String, entries: [LocationLookup])]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortIntoSections(entries: self.entries)
        self.navigationController?.navigationBar.topItem?.title = "GeoCalculator";
        self.title = "History"
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let data = self.tableViewData{
        return data.count
    } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sectionInfo = self.tableViewData?[section]
        {
            return sectionInfo.entries.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FancyCell", for: indexPath) as! HistoryTableViewCell
        //let ll = entries[indexPath.row]
        if let ll = self.tableViewData?[indexPath.section].entries[indexPath.row] {
            cell.origPoint.text = "(\(ll.origLat.roundTo(places:4)),\(ll.origLng.roundTo(places:4)))"
            cell.destPoint.text = "(\(ll.destLat.roundTo(places:4)),\(ll.destLng.roundTo(places: 4)))"
            cell.timestamp.text = ll.timestamp.description
        }
        return cell
    }

    
   /* override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath){
        // use the historyDelegate to report back entry selected to the calculator
            if let del = self.historyDelegate {
            let ll = entries[indexPath.row]
            del.selectEntry(entry: ll)
        }
        // this pops to the calculator
        _ = self.navigationController?.popViewController(animated: true)
    }*/
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) ->String? {
            return self.tableViewData?[section].sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat {
            return 200.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = FOREGROUND_COLOR
            header.contentView.backgroundColor = BACKGROUND_COLOR
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView,forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = FOREGROUND_COLOR
        header.contentView.backgroundColor = BACKGROUND_COLOR
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // use the historyDelegate to report back entry selected to the calculator scene
        if let del = self.historyDelegate {
            if let ll = self.tableViewData?[indexPath.section].entries[indexPath.row] {
                del.selectEntry(entry: ll)
        }
    }
    // this pops to the calculator
    _ = self.navigationController?.popViewController(animated: true)
    }
    
   
    
    func sortIntoSections(entries: [LocationLookup]) {
        var tmpEntries : Dictionary<String,[LocationLookup]> = [:]
        var tmpData: [(sectionHeader: String, entries: [LocationLookup])] = []
        // partition into sections
        for entry in entries {
            let shortDate = entry.timestamp.short
            if var bucket = tmpEntries[shortDate] {
                bucket.append(entry)
                tmpEntries[shortDate] = bucket
            } else {
                tmpEntries[shortDate] = [entry]
            }
        }
        // breakout into our preferred array format
        let keys = tmpEntries.keys
        for key in keys {
            if let val = tmpEntries[key] {
                tmpData.append((sectionHeader: key, entries: val))
            }
        }
        // sort by increasing date.
        tmpData.sort { (v1, v2) -> Bool in
            if v1.sectionHeader < v2.sectionHeader {
                return true
            } else {
                return false
            }
        }
        
        self.tableViewData = tmpData
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
/*extension Date {
    struct Formatter {
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    
    var short: String {
        return Formatter.short.string(from: self)
    }
}*/
extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
            return formatter
        }()
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
    }
    var short: String {
        return Formatter.short.string(from: self)
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    }
extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
        
    }
}

