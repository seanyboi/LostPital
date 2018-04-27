//
//  DiagnosisCell.swift
//  Health Application
//
//  Created by Sean O'Connor on 17/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class DiagnosisCell: UITableViewCell {

    @IBOutlet weak var suggestedDiagnosisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    
    }
    
    // Format text appropriately, in case it takes up multiple lines
    func updateUI(condition: Diagnosis.Condition) {
        suggestedDiagnosisLabel.font = UIFont(name:"Avenir", size:18)
        // Rounding to 3dp here, to avoid extremely long decimals
        let probabilityDouble = Double(condition.probability! as NSNumber)
        let probabilityRounded = Double(round(1000*probabilityDouble)/1000)
        suggestedDiagnosisLabel.text = "Condition: \(condition.name!) \nProbability: \(probabilityRounded)"
        suggestedDiagnosisLabel.numberOfLines = 0;
        suggestedDiagnosisLabel.lineBreakMode = .byWordWrapping
    }

}
