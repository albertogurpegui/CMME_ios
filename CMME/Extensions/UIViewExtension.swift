//
//  UIViewExtension.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 22/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground() {
        let colorTop = UIColor(red: 51/255.0, green: 105/255.0, blue: 154/255.0, alpha: 1.0)
        let colorDown = UIColor(red: 100/255.0, green: 198/255.0, blue: 196/255.0, alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [colorTop.cgColor, colorDown.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        /*gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)*/
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
