//
//  WaterViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 2/10/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class WaterViewController: UIViewController {
    
    @IBOutlet var drinkTimeTextView: UITextField!
    
    @IBOutlet var drinkPlaceView: UITextField!
    
    @IBOutlet var drinkQuantityView: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    let setTexField = InputTextField()
    
    let datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
    datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker}()
    var dogId:String?
    var waterString: String?
    var drinkimeData: UIDatePicker = UIDatePicker()
    var drinkTimeString: String?
    var drinkPlaceString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        drinkTimeTextView.inputView = datePicker
        toolBar()
        self.tabBarController?.tabBar.isHidden = true
        textFieldSetup()
    }
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        drinkTimeTextView.inputAccessoryView = toolBar
    }
    
    @objc func done(){
        drinkQuantityView.endEditing(true)
        drinkPlaceView.endEditing(true)
    }
    
    @IBAction func saveWaterString(_ sender: Any) {
        waterString = drinkQuantityView.text!
        drinkTimeString = drinkTimeTextView.text!
        drinkPlaceString = drinkPlaceView.text!
        
        print(waterString!)
        print(drinkTimeString!)
        print(drinkPlaceString!)
        
        let waterInfoArray:Dictionary = ["waterString": waterString as Any,"drinkTimeString": drinkTimeString as Any,"drinkPlaceString": drinkPlaceString as Any] as [String:Any]
            
        print(waterString!+"ml")
        print(drinkTimeString!)
        print(drinkPlaceString!)
        let uid = Auth.auth().currentUser?.uid
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId!)
        aDog.collection("waterInfomation").addDocument(data: waterInfoArray)
        
        self.performSegue(withIdentifier: "FinishedWater", sender: nil)
    }
    
    @objc func dateChange(){
           let formatter = DateFormatter()
           formatter.dateFormat = "MM月dd日 HH時mm分"
        drinkTimeTextView.text = "\(formatter.string(from: datePicker.date))"
       }
    
    func textFieldSetup(){
        setTexField.setPuTextField(setText: drinkTimeTextView)
        setTexField.setPuTextField(setText: drinkPlaceView)
        setTexField.setPuTextField(setText: drinkQuantityView)
        saveButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowRadius = 0.2
    }
}
