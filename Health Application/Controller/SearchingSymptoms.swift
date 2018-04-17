//
//  FurtherQuestions.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SearchingSymptoms: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchingSymptomsTableView: UITableView!
    
    var searchingArray = [Symptoms]()
    var filteredArray = [Symptoms]()
    
    var searchingUnderWay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchingSymptomsTableView.delegate = self
        searchingSymptomsTableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        let symptom1 = Symptoms(symptomName: "Headache", id: 1)
        let symptom2 = Symptoms(symptomName: "Tummy Ache", id: 2)
        let symptom3 = Symptoms(symptomName: "Vomitting", id: 3)
        let symptom4 = Symptoms(symptomName: "Aching Eyes", id: 4)
        let symptom5 = Symptoms(symptomName: "Ear Ache", id: 5)
        let symptom6 = Symptoms(symptomName: "Internal Bleeding", id: 6)
        
        searchingArray.append(symptom1)
        searchingArray.append(symptom2)
        searchingArray.append(symptom3)
        searchingArray.append(symptom4)
        searchingArray.append(symptom5)
        searchingArray.append(symptom6)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchingUnderWay {
            
            return filteredArray.count
            
        }
        
        return searchingArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedSymptom: Symptoms!
        
        if searchingUnderWay {
            
            selectedSymptom = filteredArray[indexPath.row]
            
        } else {
            
            selectedSymptom = searchingArray[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "2-3", sender: selectedSymptom)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? FurtherQuestions {
            
            if let symptoms = sender as? Symptoms {
                
                destination.symptoms = symptoms
                destination.addedSymptom = symptoms.symptomName
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = searchingSymptomsTableView.dequeueReusableCell(withIdentifier: "ExtraSymptoms", for: indexPath) as? ExtraSymptomCell {
            
            let searchingArrays: Symptoms!
            
            if searchingUnderWay {
                
                searchingArrays = self.filteredArray[indexPath.row]
                
            } else {
                
                searchingArrays = self.searchingArray[indexPath.row]
                
            }
            
            cell.updateUI(symptomNames: searchingArrays)

            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            searchingUnderWay = false
            view.endEditing(true)
            searchingSymptomsTableView.reloadData()
            
        } else {
            
            searchingUnderWay = true
            
            filteredArray = searchingArray.filter({$0.symptomName.contains(searchBar.text!)})
            
            searchingSymptomsTableView.reloadData()
            
        }
        
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}
