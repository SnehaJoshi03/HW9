//
//  SettingsViewController.swift
//  HW3
//
//  Created by Sneha Joshi and Akshay Khandgonda on 5/17/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

protocol SettingsViewControllerDelegate {
    func settingsChanged(distanceUnits: String, bearingUnits: String)
}

class SettingsViewController: UIViewController {
    
  
    @IBOutlet weak var bearingUnits: UITextField!
    @IBOutlet weak var distanceUnits: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var isDistance = true
    
    var dUnits: String?
    var bUnits : String?
    
    
    var delegate : SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
      //  distanceUnits.isUserInteractionEnabled = true
        let tapDistance = UITapGestureRecognizer(target: self, action: #selector(self.distanceTapped))
        distanceUnits.isUserInteractionEnabled = true
        self.distanceUnits.addGestureRecognizer(tapDistance)
        
   //     bearingUnits.isUserInteractionEnabled = true
        let tapBearing = UITapGestureRecognizer(target: self, action: #selector(self.bearingTapped))
        bearingUnits.isUserInteractionEnabled = true
        self.bearingUnits.addGestureRecognizer(tapBearing)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hidePicker))
        view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        guard let dStr = self.dUnits, let bStr = bUnits else {
            return
        }
        self.distanceUnits.text = dStr
        self.bearingUnits.text = bStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func distanceTapped(sender: UITapGestureRecognizer){
        print("gesture recognizer tapped1")
       self.picker.isHidden = false
        self.pickerData = ["Kilometers", "Miles"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
        self.isDistance = true
        
    }
    @objc func bearingTapped(sender: UITapGestureRecognizer){
        print("gesture recognizer tapped2")
        self.pickerData = ["Degrees", "Mils"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
        self.isDistance = false
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
       self.delegate?.settingsChanged(distanceUnits: dUnits!, bearingUnits: bUnits!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hidePicker(sender: UITapGestureRecognizer) {
        self.picker.isHidden = true
    }
}

extension SettingsViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int
    {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if self.isDistance {
            self.distanceUnits.text = self.pickerData[row]
            self.dUnits = self.pickerData[row]
        } else {
            self.bearingUnits.text = self.pickerData[row]
            self.bUnits = self.pickerData[row]
        }
    }
}
