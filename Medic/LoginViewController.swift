//
//  ViewController.swift
//  ArtsAPI
//
//  Created by Arturo Guerra on 12/11/19.
//  Copyright © 2019 Arturo Guerra. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var _username: UITextField!
    
    @IBOutlet var _password: UITextField!
    
    @IBOutlet var _login_button: UIButton!
    
    var myToken = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardFromView()
     //   let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
      //  view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        let username = _username.text
        let password = _password.text
        
        if(username == "" || password == ""){
            return
        }
        DoLogin(username!,password!)
      //  print("my token 2" + self.myToken)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuController = segue.destination as! MenuViewController
        menuController.dataToken = self.myToken
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if myToken != ""
        {
            return true
        }
        return false
    }
    
    func DoLogin(_ user:String,_ psw:String){
           let url = URL(string: "http://clinimed.com/api/login_check")
           let session = URLSession.shared
           
           var request = URLRequest(url: url!)
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.setValue("application/json", forHTTPHeaderField: "Accept")
           request.httpMethod = "POST"
           
           let dictionary = ["username": user, "password": psw]
           
           request.httpBody = try! JSONEncoder().encode(dictionary)

              let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                   if error == nil
                   {
                       do
                       {
                           let tokenRequest = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                           let token = tokenRequest["token"] as! String
                           self.myToken = token
                           print("my token " + self.myToken)
                        DispatchQueue.main.async {
                            self.loginDone()
                        }
                        
                           
                       }
                       catch let error2 as NSError
                       {
                           print(error2)
                       }
                   }
               })
               dataTask.resume()
           
           }
    
    
    func loginDone() {
        performSegue(withIdentifier: "LoginSegue", sender: Any?.self)
    }
    
    
    
    
    }




