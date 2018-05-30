//
//  HistoryTableViewCell.swift
//  HW3
//
//  Created by Sneha Joshi on 5/30/18.
//  Copyright © 2018 Sneha Joshi. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var destPoint: UILabel!
    @IBOutlet weak var origPoint: UILabel!
    @IBOutlet weak var timestamp: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
