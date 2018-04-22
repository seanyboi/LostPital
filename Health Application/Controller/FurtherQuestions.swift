//
//  FurtherQuestions.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class FurtherQuestions: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var symptoms: Symptoms!
    
    @IBOutlet weak var additionalSymptomsTableView: UITableView!
    
    var suggestedSymptomsArray = [Symptoms]()
    
    var selectedSymptoms = [Symptoms]()
    
    var clicked = [String]()
    
    //this isnt working now??
    var addedSymptom = ""
    
    var sex = "male"
    var age = 25
    var evidence = [[String:Any]]()
    var evidenceIDs = [String]()        // TODO pass this through later (should be added to on previous view, e.g. abdominal pane id)
    var extras: [String:Any] = ["disable_groups": true]
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = CGPoint(x: additionalSymptomsTableView.bounds.size.width/2, y: additionalSymptomsTableView.bounds.size.height/2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.red
        additionalSymptomsTableView.addSubview(activityIndicator)
        
        
        activityIndicator.startAnimating()
        callingApi()
        
        //evidenceIDs.append("s_21")
        
        additionalSymptomsTableView.delegate = self
        additionalSymptomsTableView.dataSource = self
        
//        let symptom1 = Symptoms(name: "Headache", id: "1")
//        let symptom2 = Symptoms(name: "Tummy Ache", id: "2")
//        let symptom3 = Symptoms(name: "Vomitting", id: "3")
//        let symptom4 = Symptoms(name: "Aching Eyes", id: "4")
//        let symptom5 = Symptoms(name: "Ear Ache", id: "5")
//        let symptom6 = Symptoms(name: "Internal Bleeding", id: "6")
//
//        suggestedSymptomsArray.append(symptom1)
//        suggestedSymptomsArray.append(symptom2)
//        suggestedSymptomsArray.append(symptom3)
//        suggestedSymptomsArray.append(symptom4)
//        suggestedSymptomsArray.append(symptom5)
//        suggestedSymptomsArray.append(symptom6)
//
//        selectedSymptoms.append(symptoms)
        
        selectedSymptoms.append(symptoms)
        clicked.append(addedSymptom)
        

    }
    
    func callingApi() {
        
        
        evidenceIDs.append("s_247")
        for evidenceID in evidenceIDs {
            evidence.append(["id": (evidenceID), "choice_id": "present", "initial": true])
        }
        //var evidence = [["id": "s_47", "choice_id": "present", "initial": true]]
        let json: [String:Any] = ["sex": sex,
                                  "age": self.age,
                                  "evidence": self.evidence,
                                  //"extras": extras
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let url = URL(string: "https://api.infermedica.com/v2/diagnosis")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("f93580b1", forHTTPHeaderField: "App-Id")
        request.setValue("e2d0f821e118e1bd3fa21290d5bc7e22", forHTTPHeaderField: "App-Key")
        //request.setValue("true", forHTTPHeaderField: "Dev-Mode")
        
        request.httpBody = jsonData
        
        getQuestions(request: request) {data in
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(responseJSON)
                
                //let question = try JSONDecoder().decode(Diagnosis.Question.self, from: data!)
                let diag = try JSONDecoder().decode(Diagnosis.self, from: data!)
                //print(ques.question.text)
                //print(ques.question.items.first!.id)
                //print(ques.question.items.first!)
                
                //var symptom: Symptoms
                //print(ques.question.items.first!.name)
                let symptom = Symptoms()
                symptom.name = diag.question.items.first!.name
                symptom.id = diag.question.items.first!.id
                print(symptom.name)
                print(symptom.id)
                self.suggestedSymptomsArray.append(symptom)
                self.updateTableViewWithSymptoms(symptoms: self.suggestedSymptomsArray)
                //print(ques.question.items.first!.name)
                //print(ques.question.items.name)
                
            } catch let error as NSError {
                print(error)
            }
        }
        
        
    }
    
    func getQuestions (request: URLRequest, completion:@escaping (Data?) -> Void) {
        
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                print(error?.localizedDescription ?? "No data")
                
                return completion(nil)
            }
            
            return completion(data)
            
            }.resume()
    }
    
    func updateTableViewWithSymptoms(symptoms: [Symptoms]) {
        
        DispatchQueue.main.async {
            
            self.additionalSymptomsTableView.reloadData()
            self.activityIndicator.stopAnimating()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = suggestedSymptomsArray[indexPath.row]
        
        let symptomName = suggestedSymptomsArray[indexPath.row].name
    
        if clicked.contains(symptomName!) {
            
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            
            cell.accessoryType = .none
            
            let indexNumber = clicked.index(of: symptomName!)
            clicked.remove(at: indexNumber!)
        
            if let element = selectedSymptoms.index(where: { $0.name == selectedRow.name }) {

                selectedSymptoms.remove(at: element)
            }
            
//            let alreadyAlert = UIAlertController(title: "Symptom Already Added", message: "\(selectedRow.name!) Has Already Been Added Before, Please Choose A Different Symptom", preferredStyle: .alert)
//
//            let alreadyAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//            alreadyAlert.addAction(alreadyAction)
//
//            self.present(alreadyAlert, animated: true, completion: nil)
            
        } else {
            
            clicked.append(symptomName!)
            
            let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
            cell.tintColor = .red
            
            additionalSymptomsTableView.reloadData()
        
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
        
        if suggestedSymptomsArray.count < 3 {
            
            performSegue(withIdentifier: "3-1", sender: selectedSymptoms)
            
        } else {
            
            if selectedSymptoms.count < 3 {
                
                let errorAlert = UIAlertController(title: "Error", message: "You Have Only Selected \(selectedSymptoms.count) Out Of A Minimum Of 2 Further Symptoms", preferredStyle: .alert)
                
                let errorAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                errorAlert.addAction(errorAction)
                
                self.present(errorAlert, animated: true, completion: nil)
                
            } else {
                
                performSegue(withIdentifier: "3-1", sender: selectedSymptoms)
                
            }
            
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
