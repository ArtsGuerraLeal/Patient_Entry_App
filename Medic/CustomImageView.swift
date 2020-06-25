//
//  CustomButton.swift
//  Medic
//
//  Created by Arturo Guerra on 12/16/19.
//  Copyright © 2019 Arturo Guerra. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImage()
    }
    
    
    func setupImage() {
      layer.cornerRadius   = 10
      layer.borderWidth    = 0
      layer.borderColor    = UIColor.blue.cgColor

    
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
