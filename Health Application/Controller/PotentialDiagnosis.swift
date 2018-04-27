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
    
    var finalDiagnosis : Diagnosis!
    var radius = 0
    var selectedRow: Diagnosis.Condition!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //diagnosisTableView.estimatedRowHeight = 300
        //diagnosisTableView.rowHeight = UITableViewAutomaticDimension
        
        diagnosisTableView.delegate = self
        diagnosisTableView.dataSource = self
        
        
    }
    
    // Updates the UITableView with necessary potential conditions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = diagnosisTableView.dequeueReusableCell(withIdentifier: "Diagnosis", for: indexPath) as? DiagnosisCell {
            let suggestedDiagnosisCondition = self.finalDiagnosis.conditions[indexPath.row]
            cell.updateUI(condition: suggestedDiagnosisCondition)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return finalDiagnosis.conditions.count
    }
    
    // Passes through necessary variables to next Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MapOfHospitals {
            
            destination.radius = radius
            destination.potentialProblem = selectedRow.name
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = self.finalDiagnosis.conditions[indexPath.row]
        performSegue(withIdentifier: "5-6", sender: selectedRow)
        
    }
    
    // Ensures the UITableViewCell always displays all text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    


}
