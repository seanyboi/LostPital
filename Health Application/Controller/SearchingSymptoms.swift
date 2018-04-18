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
    
    func getSymptomNames (request: URLRequest, completion:@escaping (Data?) -> Void) { //@escaping(([String]) -> Void)) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return completion(nil)
            }
            return completion(data)
            }.resume()
        
    }
    
    func updateTableViewWithSymptoms(symptoms: [Symptoms]) {

        DispatchQueue.main.async {
            self.searchingSymptomsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.infermedica.com/v2/symptoms")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("f93580b1", forHTTPHeaderField: "App-Id")
        request.setValue("e2d0f821e118e1bd3fa21290d5bc7e22", forHTTPHeaderField: "App-Key")
        request.setValue("true", forHTTPHeaderField: "Dev-Mode")
        
        getSymptomNames(request: request) { data in
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                let symptoms = try JSONDecoder().decode([Symptoms].self, from: data!)
                for element in symptoms {
                    self.searchingArray.append(element)
                }
                //self.searchingArray = self.symptomName
                //print(self.searchingArray)
                self.updateTableViewWithSymptoms(symptoms: self.searchingArray)
                //print(symptomNames)
                // completion(symptomNames)
                //print(symptomNames)
                // tableView(tableView: symptomCheckerTable, indexPath: "SymptomName")
                // tableView.reloadData()
                
            } catch let error as NSError {
                //completion(["aa"])
                print(error)
            }
            //self.symptomName = symptomNames
            //self.
            //print(symptomName)
        }

        searchingSymptomsTableView.delegate = self
        searchingSymptomsTableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
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
                destination.addedSymptom = symptoms.name
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
            
            filteredArray = searchingArray.filter({$0.name.contains(searchBar.text!)})
            
            searchingSymptomsTableView.reloadData()
            
        }
        
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}
