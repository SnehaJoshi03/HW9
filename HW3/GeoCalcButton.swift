//
//  GeoCalcButton.swift
//  HW3
//
//  Created by Sneha Joshi on 5/25/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit

class GeoCalcButton: UIButton {

    override func awakeFromNib() {
        self.backgroundColor = FOREGROUND_COLOR
        
        self.setTitleColor(BACKGROUND_COLOR, for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
    }

}
