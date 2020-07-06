//
//  InputTextField.swift
//  EverydayWithDog
//
//  Created by Masaki on 7/1/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit

class InputTextField: UITextField {

    func setPuTextField(setText: UITextField){
        var textField = UITextField()
        textField = setText
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 230/255, alpha: 1).cgColor
        textField.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 245/255, alpha: 1)
    }
}
