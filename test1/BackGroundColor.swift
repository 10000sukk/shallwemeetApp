//
//  BackGroundColor.swift
//  test1
//
//  Created by 김환석 on 2020/11/20.
//  Copyright © 2020 김환석. All rights reserved.
//

import Foundation

class BackGroundColor{
    
    var gradientLayer: CAGradientLayer!
    
    init() {
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer.colors = [UIColor(red: 255/255, green: 222/255, blue: 220/255, alpha: 1).cgColor, UIColor(red: 211/255, green: 238/255, blue: 249/255, alpha: 1).cgColor]
        //[UIColor(displayP3Red: 255/255, green: 222/255, blue: 220/255, alpha: 0) , UIColor(displayP3Red: 211/255, green: 238/255, blue: 249/255, alpha: 0)]
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
    }
}
