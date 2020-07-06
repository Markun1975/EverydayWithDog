//
//  ButtonBorderColor.swift
//  EverydayWithDog
//
//  Created by Masaki on 6/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ButtonBorderColor: UIButton {
        @IBInspectable var cornerRadius: CGFloat = 0.0
        @IBInspectable var borderWidth: CGFloat = 0.0
        @IBInspectable var borderColor: UIColor = UIColor.clear
        @IBInspectable var shadowColor: UIColor = UIColor.clear
        @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
        @IBInspectable var shadowOpacity: CGFloat = 0.0
        @IBInspectable var shadowRadius: CGFloat = 0
        override func draw(_ rect: CGRect) {
            layer.cornerRadius = cornerRadius
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
            clipsToBounds = true
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = Float(shadowOpacity)
            layer.shadowRadius = shadowRadius
        }
    }
