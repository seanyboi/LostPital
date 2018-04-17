//
//  FurtherQuestions.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class FurtherQuestions: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var symptoms: Symptoms = Symptoms(symptomName: "", id: 0)
    
    @IBOutlet weak var additionalSymptomsTableView: UITableView!
    
    var suggestedSymptomsArray = [Symptoms]()
    
    var selectedSymptoms = [Symptoms]()
    
    var clicked = [String]()
    
    var addedSymptom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        additionalSymptomsTableView.delegate = self
        additionalSymptomsTableView.dataSource = self
        
        let symptom1 = Symptoms(symptomName: "Headache", id: 1)
        let symptom2 = Symptoms(symptomName: "Tummy Ache", id: 2)
        let symptom3 = Symptoms(symptomName: "Vomitting", id: 3)
        let symptom4 = Symptoms(symptomName: "Aching Eyes", id: 4)
        let symptom5 = Symptoms(symptomName: "Ear Ache", id: 5)
        let symptom6 = Symptoms(symptomName: "Internal Bleeding", id: 6)
        
        suggestedSymptomsArray.append(symptom1)
        suggestedSymptomsArray.append(symptom2)
        suggestedSymptomsArray.append(symptom3)
        suggestedSymptomsArray.append(symptom4)
        suggestedSymptomsArray.append(symptom5)
        suggestedSymptomsArray.append(symptom6)
        
        selectedSymptoms.append(symptoms)
        clicked.append(addedSymptom)
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = suggestedSymptomsArray[indexPath.row]
        
        let symptomName = suggestedSymptomsArray[indexPath.row].symptomName
    
        if clicked.contains(symptomName) {
            
            let alreadyAlert = UIAlertController(title: "Symptom Already Added", message: "\(selectedRow.symptomName) Has Already Been Added Before, Please Choose A Different Symptom", preferredStyle: .alert)
            
            let alreadyAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alreadyAlert.addAction(alreadyAction)
            
            self.present(alreadyAlert, animated: true, completion: nil)
            
        } else {
            
            clicked.append(symptomName)
            
            let addedAlert = UIAlertController(title: "Symptom Added", message: "\(selectedRow.symptomName) Has Been Added", preferredStyle: .alert)
            
            let addedAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            addedAlert.addAction(addedAction)
            
            self.present(addedAlert, animated: true, completion: nil)
            
            selectedSymptoms.append(selectedRow)
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return suggestedSymptomsArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         if let cell = additionalSymptomsTableView.dequeueReusableCell(withIdentifier: "AdditionalSymptoms", for: indexPath) as? SuggestedSymptomsCell {
            
            let suggestedSymptoms = self.suggestedSymptomsArray[indexPath.row]
            
            cell.updateUI(symptomNames: suggestedSymptoms)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        if selectedSymptoms.count < 3 {
            
            let errorAlert = UIAlertController(title: "Error", message: "You Have Only Selected \(selectedSymptoms.count) Out Of A Minimum Of 2 Further Symptoms", preferredStyle: .alert)
            
            let errorAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            errorAlert.addAction(errorAction)
            
            self.present(errorAlert, animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: "3-1", sender: selectedSymptoms)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? SymptomChecker {
            
            if let symptoms = sender as? [Symptoms] {
                
                destination.symptomArray = symptoms
                destination.completedSearch = "Completed"
    
            }
        }
        
    }
    
}
