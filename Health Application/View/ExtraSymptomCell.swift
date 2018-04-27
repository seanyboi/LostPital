//
//  ExtraSymptomCell.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class ExtraSymptomCell: UITableViewCell {

    @IBOutlet weak var symptomNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
    }
    
    // Format text appropriately, in case it takes up multiple lines
    func updateUI(symptomNames: Symptoms) {
        symptomNameLabel.font = UIFont(name:"Avenir", size:18)
        symptomNameLabel.text = symptomNames.name
        symptomNameLabel.numberOfLines = 0;
        symptomNameLabel.lineBreakMode = .byWordWrapping
    }


}
