//
//  GeoCalcTextField.swift
//  HW3
//
//  Created by Sneha Joshi on 5/25/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit

class GeoCalcTextField: DecimalMinusTextField {

    override func awakeFromNib() {
     //   super.awakeFromNib()
        self.backgroundColor = BACKGROUND_COLOR
        self.backgroundColor = UIColor.clear
        
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.borderStyle = .roundedRect
        self.layer.borderColor = FOREGROUND_COLOR.cgColor
        
        self.textColor = FOREGROUND_COLOR
        
        guard let ph = self.placeholder  else {
            return
        }
        
        self.attributedPlaceholder =
            NSAttributedString(string: ph, attributes: [NSAttributedStringKey.foregroundColor:
                FOREGROUND_COLOR])
    }

}
