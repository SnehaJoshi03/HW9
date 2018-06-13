//
//  ViewController.swift
//  HW3
//
//  Created by Sneha Joshi and Akshay Khandgonda on 5/17/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class ViewController: UIViewController,SettingsViewControllerDelegate,HistoryTableTableViewControllerDelegate, UITableViewDelegate{
    
    fileprivate var ref : DatabaseReference?
    
    let wAPI = DarkSkyWeatherService.getInstance()
    
    var entries : [LocationLookup] = [
        LocationLookup(origLat: 90.0, origLng: 0.0, destLat: -90.0, destLng: 0.0,
                       timestamp: Date.distantPast),
        LocationLookup(origLat: -90.0, origLng: 0.0, destLat: 90.0, destLng: 0.0,
                       timestamp: Date.distantFuture)]
    
    @IBOutlet weak var p1Lat: DecimalMinusTextField!
    @IBOutlet weak var p1Lng: DecimalMinusTextField!
    @IBOutlet weak var p2Lat: DecimalMinusTextField!
    @IBOutlet weak var p2Lng: DecimalMinusTextField!
    
   
    @IBOutlet weak var origImage: UIImageView!
    @IBOutlet weak var origTemp: GeoCalcLabel!
    @IBOutlet weak var destImage: UIImageView!
    @IBOutlet weak var origForecast: GeoCalcLabel!
    @IBOutlet weak var destTemp: GeoCalcLabel!
    @IBOutlet weak var destForecast: GeoCalcLabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    var dunitselect : String = "Kilometers"
    var bunitselect : String = "Degrees"
    
  //  var entries :[LocationLookup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from
        self.view.backgroundColor = BACKGROUND_COLOR
        self.ref = Database.database().reference()
        self.registerForFireBaseUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.clearWeatherViews()
    }
    
    func clearWeatherViews(){
        self.destImage.image = nil
        self.origImage.image = nil
        self.destForecast.text = ""
        self.origForecast.text = ""
        self.origTemp.text = ""
        self.destTemp.text = ""
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
        
        //save history to Firebase
        let entry = LocationLookup(origLat: p1lt, origLng: p1ln, destLat: p2lt, destLng: p2ln, timestamp: Date())
        let newChild = self.ref?.child("history").childByAutoId()
        newChild?.setValue(self.toDictionary(vals: entry))
        
       // entries.append(LocationLookup(origLat: p1lt, origLng: p1ln, destLat: p2lt,destLng: p2ln, timestamp: Date()))
        
        wAPI.getWeatherForDate(date: Date(), forLocation: (p1lt, p1ln)){ (weather) in
            if let w = weather {
                DispatchQueue.main.async {
                    self.origTemp.text = "\(w.temperature.roundTo(places: 1)) º"
                    self.origImage.image = UIImage(named: w.iconName)
                    self.origForecast.text = w.summary
                }
            }
        }
        wAPI.getWeatherForDate(date: Date(), forLocation: (p2lt, p2ln)){ (weather) in
            if let w = weather {
                DispatchQueue.main.async {
                    self.destTemp.text = "\(w.temperature.roundTo(places: 1)) º"
                    self.destImage.image = UIImage(named: w.iconName)
                    self.destForecast.text = w.summary
                }
            }
        }
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
                dest.historyDelegate = self
            } 
            
        }else if segue.identifier == "settingsSegue"{
            if let dest = segue.destination as? SettingsViewController {
                dest.dUnits = self.dunitselect
                dest.bUnits = self.bunitselect
                dest.delegate = self
        }
        }
            else if segue.identifier == "searchSegue"{
                if let dest = segue.destination as? LocationSearchViewController {
                    dest.delegate = self
                }
            }
        }
    
    fileprivate func registerForFireBaseUpdates()
    {
        self.ref!.child("history").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [LocationLookup]()
                for (_,val) in postDict.enumerated() {
                    let entry = val.1 as! Dictionary<String,AnyObject>
                    let timestamp = entry["timestamp"] as! String?
                    let origLat = entry["origLat"] as! Double?
                    let origLng = entry["origLng"] as! Double?
                    let destLat = entry["destLat"] as! Double?
                    let destLng = entry["destLng"] as! Double?
                    tmpItems.append(LocationLookup(origLat: origLat!, origLng: origLng!, destLat: destLat!, destLng: destLng!,
                                                   timestamp: (timestamp?.dateFromISO8601)!))
                }
                self.entries = tmpItems }
        })
    }
    
    func toDictionary(vals: LocationLookup) -> NSDictionary { return [
        "timestamp": NSString(string: (vals.timestamp.iso8601)), "origLat" : NSNumber(value: vals.origLat),
        "origLng" : NSNumber(value: vals.origLng),
        "destLat" : NSNumber(value: vals.destLat),
        "destLng" : NSNumber(value: vals.destLng), ]
    }
}

extension ViewController: LocationSearchDelegate {
    func set(calculationData: LocationLookup)
{
    self.p1Lat.text = "\(calculationData.origLat)"
    self.p1Lng.text = "\(calculationData.origLng)"
    self.p2Lat.text = "\(calculationData.destLat)"
    self.p2Lng.text = "\(calculationData.destLng)"
    self.doCalculatations()
    }
    
}







