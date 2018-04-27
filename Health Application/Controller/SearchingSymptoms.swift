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
    
    var selectedSymptoms = [Symptoms]()
    
    var clicked = [String]()
    
    var searchingUnderWay = false
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.center = CGPoint(x: searchingSymptomsTableView.bounds.size.width/2, y: searchingSymptomsTableView.bounds.size.height/2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.red
        searchingSymptomsTableView.addSubview(activityIndicator)
        
        
        activityIndicator.startAnimating()
        callingAPI()

        searchingSymptomsTableView.delegate = self
        searchingSymptomsTableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // Function for setting up GET request for diagnosis from Infermedica
    func callingAPI() {
        
        let url = URL(string: "https://api.infermedica.com/v2/symptoms")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("f93580b1", forHTTPHeaderField: "App-Id")
        request.setValue("e2d0f821e118e1bd3fa21290d5bc7e22", forHTTPHeaderField: "App-Key")
        request.setValue("true", forHTTPHeaderField: "Dev-Mode")
        
        // Closure necessary to ensure asynchronous API call is completed before updating
        // UITableView
        getSymptomNames(request: request) { data in
            do {
                
                _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                let symptoms = try JSONDecoder().decode([Symptoms].self, from: data!)
                
                for element in symptoms {
                    
                    self.searchingArray.append(element)
                    
                }
                
                self.updateTableViewWithSymptoms(symptoms: self.searchingArray)
                
            } catch let error as NSError {
                
                print(error)
                
            }
        }
        
        
    }

    // Send the request to the URL, uses a completionHandler to ensure we obtain
    // data, and handle cases where the URL does not respond
    func getSymptomNames (request: URLRequest, completion: @escaping (Data?) -> Void) {
        
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                
                return completion(nil)
            }
            
            return completion(data)
            
            }.resume()
        
    }
    
    // Updates the UITableView once the asynchronous API call has been completed
    func updateTableViewWithSymptoms(symptoms: [Symptoms]) {
        DispatchQueue.main.async {
            self.searchingSymptomsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchingUnderWay {
            
            return filteredArray.count
            
        }
        
        return searchingArray.count
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = searchingSymptomsTableView.dequeueReusableCell(withIdentifier: "ExtraSymptoms", for: indexPath) as? ExtraSymptomCell {
            
            let searchingArrays: Symptoms!
            
            let symptomName: String!
            
            if searchingUnderWay {
                
                searchingArrays = self.filteredArray[indexPath.row]
                symptomName = filteredArray[indexPath.row].name as String
            
                
            } else {
                
                searchingArrays = self.searchingArray[indexPath.row]
                symptomName = searchingArray[indexPath.row].name as String
                                
            }
            
            if clicked.contains(symptomName)  {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            cell.updateUI(symptomNames: searchingArrays)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow: Symptoms!
        
        let symptomName: String!
        
        let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        if searchingUnderWay {
            
            selectedRow = filteredArray[indexPath.row]
            symptomName = filteredArray[indexPath.row].name as String
            
            if clicked.contains(symptomName) {
                
                cell.accessoryType = .none

                let indexNumber = clicked.index(of: symptomName)
                clicked.remove(at: indexNumber!)

                if let element = selectedSymptoms.index(where: { $0.name == selectedRow.name }) {

                    selectedSymptoms.remove(at: element)
                }

            } else {
                
                clicked.append(symptomName)

                cell.accessoryType = .checkmark

                searchingSymptomsTableView.reloadData()

                selectedSymptoms.append(selectedRow)

            }
            
            
        
        } else {
            
            selectedRow = searchingArray[indexPath.row]
            symptomName = searchingArray[indexPath.row].name as String

            if clicked.contains(symptomName) {
                
                cell.accessoryType = .none

                let indexNumber = clicked.index(of: symptomName)
                clicked.remove(at: indexNumber!)

                if let element = selectedSymptoms.index(where: { $0.name == selectedRow.name }) {

                    selectedSymptoms.remove(at: element)
                }

            } else {
                
                clicked.append(symptomName)
                
                cell.accessoryType = .checkmark
                
                searchingSymptomsTableView.reloadData()

                selectedSymptoms.append(selectedRow)

            }
            
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
    

    @IBAction func proceedBtn(_ sender: Any) {
        
        if selectedSymptoms.count < 3 {
            
            let errorAlert = UIAlertController(title: "Error", message: "You Have Only Selected \(selectedSymptoms.count) Out Of A Minimum Of 3 Symptoms", preferredStyle: .alert)
            
            let errorAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            errorAlert.addAction(errorAction)
            
            self.present(errorAlert, animated: true, completion: nil)

        
        } else {
            
            performSegue(withIdentifier: "2-1", sender: selectedSymptoms)
            
        }
        

        
    }
    
    // Passes through necessary variables to next Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let destination = segue.destination as? SymptomChecker {

            destination.symptomArray = sender as! [Symptoms]
            destination.completedSearch = "Completed"
                
        }
    
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}
