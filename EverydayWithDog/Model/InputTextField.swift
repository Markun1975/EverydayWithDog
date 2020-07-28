//
//  InputTextField.swift
//  EverydayWithDog
//
//  Created by Masaki on 7/1/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit

@IBDesignable class InputTextField: UITextField{
    @IBInspectable var cornerRadius: CGFloat = 0.0
        @IBInspectable var borderWidth: CGFloat = 0.0
        @IBInspectable var borderColor: UIColor = UIColor.clear
        @IBInspectable var shadowColor: UIColor = UIColor.clear
        @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
        @IBInspectable var shadowOpacity: CGFloat = 0.0
        @IBInspectable var shadowRadius: CGFloat = 0
        @IBInspectable var padding: CGPoint = CGPoint(x: 10.0, y: 0.0)
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
     override func textRect(forBounds bounds: CGRect) -> CGRect {
          // テキストの内側に余白を設ける
          return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
      }

      override func editingRect(forBounds bounds: CGRect) -> CGRect {
          // 入力中のテキストの内側に余白を設ける
          return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
      }

      override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
          // プレースホルダーの内側に余白を設ける
          return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
      }
    }

    

//    func setPuTextField(setText: UITextField){
//        var textField = UITextField()
//        textField = setText
//        textField.layer.cornerRadius = 6
//        textField.layer.borderWidth = 0.8
//        textField.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 230/255, alpha: 1).cgColor
//        textField.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 245/255, alpha: 1)
//        //textFieldの内側にPaddingを調整
//    }


