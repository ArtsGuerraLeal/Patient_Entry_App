//
//  NewAddressViewController.swift
//  Medic
//
//  Created by Arturo Guerra on 12/15/19.
//  Copyright © 2019 Arturo Guerra. All rights reserved.
//

import UIKit

class NewAddressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StateData.count
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return StateData[row]

    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _state.text = StateData[row]
        _stateId = row
       }
    
    var StateData = [String]()

    
    
    var dataToken = String()
    var patientData = Int()

    @IBOutlet var _line1: UITextField!
    
    @IBOutlet var _line2: UITextField!
    
    @IBOutlet var _postalCode: UITextField!
    
    @IBOutlet var _city: UITextField!
    
    @IBOutlet var _state: UITextField!
    
    var _stateId: Int = 0
    
    var _addressId: Int = 0
    
    let statePicker = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardFromView()
        getStates(dataToken)
        _state.inputView = statePicker
        statePicker.delegate = self
        print("This is the data in Address ")
        print(patientData)

    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuController = segue.destination as! MenuViewController
                   menuController.dataToken = dataToken
    }
    
    @IBAction func _donePress(_ sender: Any) {
        preparePost(dataToken, _line1.text!, _line2.text!, _postalCode.text!, _city.text!, _stateId)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if _line1.text != ""{
            return true
        }
        return false
    
    }
    
    func getStates(_ token:String) {
        let url = URL(string: "http://clinimed.com/api/states")
           
              // create post request
              var request = URLRequest(url: url!)
              request.httpMethod = "GET"

              // insert json data to the request
              
              request.addValue("application/json", forHTTPHeaderField: "Content-Type")
              request.addValue("application/json", forHTTPHeaderField: "Accept")
              request.addValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

              let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
              guard let dataResponse = data,
                        error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                  do{
                      //here dataResponse received from a network request
                      let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                  //    print(jsonResponse) //Response result
                    
                       guard let jsonArray = jsonResponse as? [[String: Any]] else {return}
                                        
                    for x in 0..<jsonArray.count{
                        let stateName = jsonArray[x]["name"] as! String
                        self.StateData.append(stateName)
                    }
                    
                   } catch let parsingError {
                      print("Error", parsingError)
                 }
              }
              task.resume()
        
    }
    
    
    func preparePost(_ token:String,_ line1:String,_ line2:String,_ postalCode:String,_ city:String,_ stateId:Int){
           let url = URL(string: "http://clinimed.com/api/addresses")
        let json: [String: Any] = ["line1": line1,"line2":line2,"postalCode":postalCode,"city": city,"stateId":stateId]

           let jsonData = try? JSONSerialization.data(withJSONObject: json)

           // create post request
           var request = URLRequest(url: url!)
           request.httpMethod = "POST"

           // insert json data to the request
           request.httpBody = jsonData
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   print(error?.localizedDescription ?? "No data")
                   return
               }
               let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
                if let responseJSON = responseJSON as? [String: Any] {
                          print(responseJSON)
                    
                    DispatchQueue.main.async {
                        self.doAddress(jsonResponse: responseJSON )
                    }
                      }
            
              
        //    guard let jsonArray = responseJSON as? [[String: Any]] else {return}
            
            
               
           }

           task.resume()
           
       }
    
    func preparePatch(_ token:String,_ patientId:String,_ addressId:Int){
        let url = URL(string: "http://clinimed.com/api/patients/" + patientId + "/address")
          let json: [String: Any] = ["addressId": addressId]

             let jsonData = try? JSONSerialization.data(withJSONObject: json)

             // create post request
             var request = URLRequest(url: url!)
             request.httpMethod = "PATCH"

             // insert json data to the request
             request.httpBody = jsonData
             request.addValue("application/json", forHTTPHeaderField: "Content-Type")
             request.addValue("application/json", forHTTPHeaderField: "Accept")
             request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                 guard let data = data, error == nil else {
                     print(error?.localizedDescription ?? "No data")
                     return
                 }
                 let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                 if let responseJSON = responseJSON as? [String: Any] {
                     print(responseJSON)
                    
                    DispatchQueue.main.async {
                                           self.doPatientPatch()
                                     }
                 }
             }

             task.resume()
             
         }
    
        func doAddress(jsonResponse:[String: Any]){
        
       if let number = jsonResponse["id"] as? Int {
                   print(number)
                     self._addressId = number
                         }
    preparePatch(dataToken, String(patientData), _addressId)

    }
    
    func doPatientPatch(){
        
    performSegue(withIdentifier: "MenuSegue", sender: Any?.self)

    }
   

}
