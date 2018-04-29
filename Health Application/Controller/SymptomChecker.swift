//
//  ViewController.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SymptomChecker: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //Initialisation of Views
    
    @IBOutlet weak var additionalInfoStack: UIStackView!
    
    @IBOutlet weak var symptomCheckerTable: UITableView!
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var yearOfBirthTextField: UITextField!
    
    @IBOutlet weak var searchSymptomsBtn: UIButton!
    
    @IBOutlet weak var searchingSymptoms: UIButton!
    
    @IBOutlet weak var radiusTextField: UITextField!
    
    var symptomArray = [Symptoms]()
    var completedSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Determines whether a user has selected their symptoms yet. Views hidden until done so.
        
        if completedSearch == "Completed" {
            
            searchSymptomsBtn.isHidden = true
            searchingSymptoms.isHidden = false
            additionalInfoStack.isHidden = false
            
        } else {
            
            searchingSymptoms.isHidden = true
            additionalInfoStack.isHidden = true
            
        }

        //Must set delegates.
        symptomCheckerTable.delegate = self
        symptomCheckerTable.dataSource = self
        yearOfBirthTextField.delegate = self
        radiusTextField.delegate = self
        
    }
    
    //Places array data into tableview.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = symptomCheckerTable.dequeueReusableCell(withIdentifier: "SymptomName", for: indexPath) as? SymptomCell{
            
            let symptomName = self.symptomArray[indexPath.row]
            
            cell.updateUI(symptomNames: symptomName)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    //Determines how many rows tableview will have.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return symptomArray.count
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
        
    }
    
    
    //Allows navigation to next controller.
    
    func integerCheck(stringBeingChecked: String) -> Bool {
        
        return Int(stringBeingChecked) != nil
    }

    //Logic check before searching, checks whether user inputs are valid
    
    @IBAction func searchButton(_ sender: Any) {
        
        if (yearOfBirthTextField.text == "" && radiusTextField.text == "") || yearOfBirthTextField.text == "" || radiusTextField.text == "" {
            
            let errorAlert = UIAlertController(title: "Error", message: "Please ensure you have entered an age and a radius for search", preferredStyle: .alert)
            
            let errorAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            errorAlert.addAction(errorAction)
            
            self.present(errorAlert, animated: true, completion: nil)
            
        } else if integerCheck(stringBeingChecked: radiusTextField.text!) == false || integerCheck(stringBeingChecked: yearOfBirthTextField.text!) == false {
            
            let errorAlert = UIAlertController(title: "Error", message: "Please ensure you have entered an integer as the age or radius", preferredStyle: .alert)
            
            let errorAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            errorAlert.addAction(errorAction)
            
            self.present(errorAlert, animated: true, completion: nil)
            
        }  else if (Int(radiusTextField.text!)! < 1000 && Int(yearOfBirthTextField.text!)! > 130) || Int(radiusTextField.text!)! < 1000 || Int(yearOfBirthTextField.text!)! > 130 {
            
            let errorAlert = UIAlertController(title: "Error", message: "Please ensure your Radius is greater than 1000m and your Age is less than 130", preferredStyle: .alert)
            
            let errorAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            errorAlert.addAction(errorAction)
            
            self.present(errorAlert, animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: "1-4", sender: symptomArray)
        }
        
        
    }
    
    // Passes through necessary variables to next Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DiagnosisQuestions {
            
            destination.selectedSymptoms = sender as! [Symptoms]
            destination.age = Int(yearOfBirthTextField.text!)!
            destination.radius = Int(radiusTextField.text!)!
            destination.sex = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)!.lowercased()
            
            
        }
        
    }
    
    
    @IBAction func addingSymptomButton(_ sender: Any) {
        
        performSegue(withIdentifier: "1-2", sender: nil)
        
    }

}

