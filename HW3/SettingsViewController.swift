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
        
        distanceUnits.isUserInteractionEnabled = true
        let tapDistance = UITapGestureRecognizer(target: self, action: #selector(self.distanceTapped))
        distanceUnits.isUserInteractionEnabled = true
        self.distanceUnits.addGestureRecognizer(tapDistance)
        
        bearingUnits.isUserInteractionEnabled = true
        let tapBearing = UITapGestureRecognizer(target: self, action: #selector(self.bearingTapped))
        bearingUnits.isUserInteractionEnabled = true
        self.bearingUnits.addGestureRecognizer(tapBearing)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hidePicker))
        view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func distanceTapped(sender: UITapGestureRecognizer){
        print("gesture recognizer tapped1")
      //  self.picker.isHidden = false
        self.pickerData = ["Kilometers", "Miles"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
     //   self.isDistance = true
        
    }
    
    @objc func bearingTapped(sender: UITapGestureRecognizer){
        print("gesture recognizer tapped2")
        self.pickerData = ["Degrees", "Mils"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
     //   self.isDistance = false
    }
    
    @objc func hidePicker(sender: UITapGestureRecognizer) {
        self.picker.isHidden = true
    }
    
    override func prepare(for segue : UIStoryboardSegue, sender : Any?)
    {
        if (segue.identifier == "goS") {
            guard let vc = segue.destination as? ViewController else { return}
            vc.dunitselect = dUnits!
            vc.bunitselect = bUnits!
        }
        
    }
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
   /* @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let del = self.delegate {
            distanceUnits.text = dUnits
            bearingUnits.text = bUnits
           
            del.settingsChanged(distanceUnits: self.dUnits!, bearingUnits: self.bUnits!)
        }
        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }*/
    
   /* override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let d = self.delegate {
            distanceUnits.text = dUnits
            bearingUnits.text = bUnits
            d.settingsChanged(distanceUnits: dUnits!, bearingUnits: bUnits!)
        }
    }*/
    
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
        if (self.pickerData[0]=="Kilometers" || self.pickerData[1]=="Kilometers") {
            self.distanceUnits.text = self.pickerData[row]
            self.dUnits = self.pickerData[row]
        } else {
            self.bearingUnits.text = self.pickerData[row]
            self.bUnits = self.pickerData[row]
        }
    }
}
