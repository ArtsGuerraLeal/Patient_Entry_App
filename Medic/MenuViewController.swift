//
//  MenuViewController.swift
//  Medic
//
//  Created by Arturo Guerra on 12/15/19.
//  Copyright © 2019 Arturo Guerra. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var dataToken = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPatient(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let patientController = segue.destination as! NewPatientViewController
             patientController.dataToken = dataToken
        
    }
   
  

}
