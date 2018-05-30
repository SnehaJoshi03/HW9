//
//  ViewController.swift
//  HW3
//
//  Created by Sneha Joshi and Akshay Khandgonda on 5/17/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,SettingsViewControllerDelegate,HistoryTableTableViewControllerDelegate, UITableViewDelegate{
    
    
    @IBOutlet weak var p1Lat: DecimalMinusTextField!
    @IBOutlet weak var p1Lng: DecimalMinusTextField!
    @IBOutlet weak var p2Lat: DecimalMinusTextField!
    @IBOutlet weak var p2Lng: DecimalMinusTextField!
    
   
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    var dunitselect : String = "Kilometers"
    var bunitselect : String = "Degrees"
    
    var entries :[LocationLookup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from
        self.view.backgroundColor = BACKGROUND_COLOR
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func settingsChanged(distanceUnits: String, bearingUnits: String){
       self.dunitselect = distanceUnits
        self.bunitselect = bearingUnits
        self.doCalculatations()
        self.view.endEditing(true)
    }
    
    func selectEntry(entry: LocationLookup) {
        self.p1Lat.text = "\(entry.origLat)"
        self.p1Lng.text = "\(entry.origLng)"
        self.p2Lat.text = "\(entry.destLat)"
        self.p2Lng.text = "\(entry.destLng)"
        self.doCalculatations()
    }
    
    func doCalculatations()
    {
        guard let p1lt = Double(self.p1Lat.text!), let p1ln = Double(self.p1Lng.text!), let p2lt = Double(self.p2Lat.text!), let p2ln = Double(p2Lng.text!) else {
            return
        }
        let p1 = CLLocation(latitude: p1lt, longitude: p1ln)
        let p2 = CLLocation(latitude: p2lt, longitude: p2ln)
        let distance = p1.distance(from: p2)
        let bearing = p1.bearingToPoint(point: p2)
        
        if dunitselect == "Kilometers" {
            self.distanceLabel.text = "Distance \((distance / 10.0).rounded() / 100.0) kilometer"
        } else {
            self.distanceLabel.text = "Distance \((distance * 0.0621371).rounded() / 100.0 ) miles "
        }
        
        if bunitselect == "Degrees" {
            self.bearingLabel.text = "Bearing \((bearing * 100).rounded() / 100.0) degrees"
        } else {
            self.bearingLabel.text = "Bearing \((bearing * 1777.7777777778).rounded() / 100.0) mils"
        }
    
        entries.append(LocationLookup(origLat: p1lt, origLng: p1ln, destLat: p2lt,destLng: p2ln, timestamp: Date()))
    }
    
   
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        self.doCalculatations()
        self.view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        self.p1Lat.text = ""
        self.p1Lng.text = ""
        self.p2Lat.text = ""
        self.p2Lng.text = ""
        self.distanceLabel.text = " "
        self.bearingLabel.text = " "
        self.view.endEditing(true)  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "historySegue"{
            if let dest = segue.destination as? HistoryTableTableViewController {
              dest.entries = self.entries
                dest.delegate = self
            } 
            
        }else if segue.identifier == "settingsSegue"{
            if let dest = segue.destination as? SettingsViewController {
                dest.dUnits = self.dunitselect
                dest.bUnits = self.bunitselect
                dest.delegate = self
        }
       }
    }
    

}





