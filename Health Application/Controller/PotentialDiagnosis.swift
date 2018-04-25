//
//  PotentialDiagnosis.swift
//  Health Application
//
//  Created by Sean O'Connor on 17/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class PotentialDiagnosis: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var diagnosisTableView: UITableView!
    
    var suggestedDiagnosisArray = [Diagnosis]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let diagnosis1 = Diagnosis()
        let diagnosis2 = Diagnosis()
        let diagnosis3 = Diagnosis()
        suggestedDiagnosisArray.append(diagnosis1)
        suggestedDiagnosisArray.append(diagnosis2)
        suggestedDiagnosisArray.append(diagnosis3)
        
        diagnosisTableView.delegate = self
        diagnosisTableView.dataSource = self
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = diagnosisTableView.dequeueReusableCell(withIdentifier: "Diagnosis", for: indexPath) as? DiagnosisCell {
            
            let suggestedDiagnosis = self.suggestedDiagnosisArray[indexPath.row]
            
            cell.updateUI(diagnosis: suggestedDiagnosis)
                        
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return suggestedDiagnosisArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = suggestedDiagnosisArray[indexPath.row]
        
        performSegue(withIdentifier: "5-6", sender: selectedRow)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MapOfHospitals {
            
            if let diagnosis = sender as? [Diagnosis] {
                
                destination.potentialProblem = diagnosis
                
                
            }
        }
        
        
    }


}
