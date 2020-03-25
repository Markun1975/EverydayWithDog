//
//  timeManagement.swift
//  EverydayWithDog
//
//  Created by Masaki on 2/14/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import UIKit

class TimeManagement {
    
           var timeTextView: UITextView!
           var contentsTextView: UITextField!
           
           var timeString: String?
           var contentsString: String?
           var volumeString: String?
           var placeString: String?
           var timeData: UIDatePicker = UIDatePicker()
           
           let datePicker: UIDatePicker = {
                 let datePicker = UIDatePicker()
                 datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
                 datePicker.locale = Locale(identifier: "ja_JP")
            datePicker.addTarget(datePicker, action:#selector(dateChange), for: .valueChanged); return datePicker}()
    
    func toolBar(){
           let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
           let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
           let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
           toolBar.setItems([spaceItem, doneItem], animated: true)
           contentsTextView.inputAccessoryView = toolBar
       }
    
    @objc func done(){
           contentsTextView.endEditing(true)
       }
    
    @objc func dateChange(){
              let formatter = DateFormatter()
              formatter.dateFormat = "MM月dd日 HH時mm分"
              timeTextView.text = "\(formatter.string(from: datePicker.date))"
          }
}
