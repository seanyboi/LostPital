//
//  SuggestedSymptoms.swift
//  Health Application
//
//  Created by Sean O'Connor on 12/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SuggestedSymptomsCell: UITableViewCell {

    @IBOutlet weak var suggestedSymptomLabel: UILabel!
        

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(symptomNames: Symptoms) {
        
        suggestedSymptomLabel.text = symptomNames.name
        
    }

    

}
