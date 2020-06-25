//
//  DismissKeyboard.swift
//  Medic
//
//  Created by Arturo Guerra on 12/15/19.
//  Copyright © 2019 Arturo Guerra. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    // This function is called when the tap is recognized
    func dismissKeyboardFromView() {
       let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
       view.addGestureRecognizer(tap)
        
        
    }
}
