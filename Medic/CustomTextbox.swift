//
//  CustomButton.swift
//  Medic
//
//  Created by Arturo Guerra on 12/16/19.
//  Copyright © 2019 Arturo Guerra. All rights reserved.
//

import UIKit

class CustomTextbox: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextbox()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextbox()
    }
    
    
    func setupTextbox() {
      let border = CALayer()
      let width = CGFloat(1.8)
      border.borderColor = CGColor(srgbRed: 42/255, green: 126/255, blue: 254/255, alpha: 1.0)
      border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
      border.borderWidth = width
  //      self.borderStyle = UITextField.BorderStyle(rawValue: 0)!
      self.layer.addSublayer(border)
      self.layer.masksToBounds = true
        //        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes:[NSAttributedString.Key.foregroundColor : UIColor.gray])

    
    }
    
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
    
    func shake() {
        let shake           = CABasicAnimation(keyPath: "position")
        shake.duration      = 0.1
        shake.repeatCount   = 2
        shake.autoreverses  = true
        
        let fromPoint       = CGPoint(x: center.x - 8, y: center.y)
        let fromValue       = NSValue(cgPoint: fromPoint)
        
        let toPoint         = CGPoint(x: center.x + 8, y: center.y)
        let toValue         = NSValue(cgPoint: toPoint)
        
        shake.fromValue     = fromValue
        shake.toValue       = toValue
        
        layer.add(shake, forKey: "position")
    }
}
