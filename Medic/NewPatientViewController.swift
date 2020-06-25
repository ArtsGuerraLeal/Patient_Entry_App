//
//  NewPatientViewController.swift
//  Medic
//
//  Created by Arturo Guerra on 12/15/19.
//  Copyright © 2019 Arturo Guerra. All rights reserved.
//

import UIKit

class NewPatientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var dataToken = String()
    var patientData = Int()
    
    @IBOutlet var _firstName: UITextField!
    
    @IBOutlet var _lastName: UITextField!
    
    @IBOutlet var _gender: UITextField!
    
    @IBOutlet var _birthday: UITextField!
    
    @IBOutlet var _email: UITextField!
    
    @IBOutlet var _phone: UITextField!
    
    @IBOutlet var _maritalStatus: UITextField!
    
    @IBOutlet var _imageView: UIImageView!
    
    let genderPicker = UIPickerView()

    let maritalStatusPicker = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if genderPicker == pickerView{
            return GenderData.count
        } else if maritalStatusPicker == pickerView{
            return MaritalStatusData.count
        }else{
            return 1
        }
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if genderPicker == pickerView{
             return GenderData[row]
         } else if maritalStatusPicker == pickerView{
             return MaritalStatusData[row]
         }else{
             return "Error"
         }
    }
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if genderPicker == pickerView{
             _gender.text = GenderData[row]
         } else if maritalStatusPicker == pickerView{
             _maritalStatus.text = MaritalStatusData[row]
         }
    }
    
    let GenderData = [String](arrayLiteral: "Male", "Female")
    
    let MaritalStatusData = [String](arrayLiteral: "Single", "Married")
    
    lazy var datePicker: UIDatePicker = {
        
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    
    
    lazy var dateFormatter: DateFormatter = {
         
         let formatter = DateFormatter()
         
         formatter.dateStyle = .medium
         
         formatter.timeStyle = .none
        
        formatter.dateFormat = "yyyy-MM-dd"

         return formatter
     }()
    
    
    @IBAction func uploadButton(_ sender: Any) {
        ImageUploadRequest(dataToken, "57")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardFromView()
        _birthday.inputView = datePicker
        _gender.inputView = genderPicker
        genderPicker.delegate = self

        _maritalStatus.inputView = maritalStatusPicker
        maritalStatusPicker.delegate = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addressController = segue.destination as! NewAddressViewController
                   addressController.dataToken = dataToken
        addressController.patientData = patientData
    }
   
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if _firstName.text != "" && _lastName.text != "" && _phone.text != "" && _email.text != "" && _gender.text != "" && _birthday.text != "" && patientData != 0
               {
                   return true
               }
               return false
    }
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        
        _birthday.text = dateFormatter.string(from: sender.date)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         view.endEditing(true)
     }
    
    @IBAction func _nextPress(_ sender: Any) {
        let firstName = _firstName.text!
        let lastName = _lastName.text!
        let gender = _gender.text!
        let birthday = _birthday.text!
        let email = _email.text!
        let phone = _phone.text!
        
        let token = dataToken
        
        preparePost(token,firstName,lastName,gender,birthday,email,phone)
        print("This is the data in Patient ")
        print(patientData)

    }
    
    func preparePost(_ token:String,_ firstName:String,_ lastName:String,_ gender:String,_ birthday:String,_ email:String,_ phone:String){
        let url = URL(string: "http://clinimed.com/api/patients")
     let json: [String: Any] = ["firstName": firstName,"lastName":lastName,"gender":lastName,"maritalStatusId": 1,"birthday":birthday,"email":email,"phone":phone,"religion":"Apple","companyId":3]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                     guard let dataResponse = data,
                               error == nil else {
                               print(error?.localizedDescription ?? "Response Error")
                               return }
                         do{
                             //here dataResponse received from a network request
                             let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                            print(jsonResponse) //Response result
                         
                         DispatchQueue.main.async {
                            self.doPost(jsonResponse: jsonResponse as! [String : Any])
                      }
                         
                         //       let patientData = jsonArray![0]["id"] as! String
                      
                           
                          } catch let parsingError {
                             print("Error", parsingError)
                        }
                     }
                     task.resume()
        
    }
    
    
    @IBAction func TakePicture(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraDevice = .front
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        _imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
    }
    
    func doPost(jsonResponse:[String: Any]){
        
        if let number = jsonResponse["id"] as? Int {
              print(number)
                self.patientData = number
                    }
    
    performSegue(withIdentifier: "AddressSegue", sender: Any?.self)

    }
    

    
    
    func ImageUploadRequest(_ token:String,_ patientId:String)
       {

        
        let url = URL(string: "http://clinimed.com/api/patients/" + patientId + "/image");
       

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let param = ["_method" : "PATCH"]
        let boundary = "Boundary-\(NSUUID().uuidString)"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        if (_imageView.image == nil)
        {
            return
        }
        
        let imageData = _imageView.image!.jpegData(compressionQuality: 0.5)

        if imageData == nil {
            return
        }
    
        request.httpBody = createBodyWithParams(parameters: param, filePathKey: "image", imageDataKey: imageData! as NSData, boundary: boundary) as Data

        let session = URLSession.shared
        
           session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    } catch {
                        print(error)
                    }
                }
                }.resume()
        }
       
       
       func generateBoundaryString() -> String {
        return "boundary=\(NSUUID().uuidString)"
       }
    
  func createBodyWithParams(parameters: [String : String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> Data {

      var body = Data();

      if parameters != nil {
          for (key, value) in parameters! {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
          }
      }

      let filename = "image.jpg"

      let mimetype = "image/jpg"

    body.append("--\(boundary)\r\n")
    body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
      body.append("Content-Type: \(mimetype)\r\n\r\n")
      body.append(imageDataKey as Data)
      body.append("\r\n")

      body.append("--\(boundary)--\r\n")

      return body
  }
    
    /*
    func preparePost(_ token:String,_ firstName:String,_ lastName:String,_ gender:String,_ birthday:String,_ email:String,_ phone:String){
           let url = URL(string: "http://artsauce.servebeer.com/api/patients")
        let json: [String: Any] = ["firstName": firstName,"lastName":lastName,"gender":lastName,"maritalStatusId": 1,"birthday":birthday,"email":email,"phone":phone,"religion":"Apple"]

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
               if let responseJSON = responseJSON as? [[String: Any]] {
                    
                   print(responseJSON)
                guard (responseJSON as? [[String: Any]]) != nil else {return}
                   self.patientData = responseJSON[0]["id"] as! String
               }
            
        
            
           }

           task.resume()
           
       }
     */
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
