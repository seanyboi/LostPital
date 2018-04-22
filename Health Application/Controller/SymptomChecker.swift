//
//  ViewController.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SymptomChecker: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var additionalInfoStack: UIStackView!
    
    @IBOutlet weak var symptomCheckerTable: UITableView!
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var yearOfBirthTextField: UITextField!
    
    @IBOutlet weak var searchSymptomsBtn: UIButton!
    
    @IBOutlet weak var searchingSymptoms: UIButton!
    
    var symptomArray = [Symptoms]()
    var completedSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    

    //Allows navigation to next controller.

    @IBAction func searchButton(_ sender: Any) {
        
        performSegue(withIdentifier: "1-4", sender: nil)
        
    }
    
    @IBAction func addingSymptomButton(_ sender: Any) {
        
        performSegue(withIdentifier: "1-2", sender: nil)
        
    }

}

