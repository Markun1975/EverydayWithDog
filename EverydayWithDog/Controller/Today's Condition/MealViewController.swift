//
//  MealViewController.swift
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

class MealViewController: UIViewController {
    
    @IBOutlet var mealQuantityView: UITextField!
    
    @IBOutlet var mealTimeTextView: UITextField!
    
    @IBOutlet var mealContentTextView: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    let setTexField = InputTextField()
    
        var dogId:String?
        var mealString: String?
        var mealTimeData: UIDatePicker = UIDatePicker()
        var mealTimeString: String?
        var mealContentString: String?
    
    let datePicker: UIDatePicker = {
               let datePicker = UIDatePicker()
               datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
               datePicker.locale = Locale(identifier: "ja_JP")
               datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
               return datePicker
           }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        mealTimeTextView.inputView = datePicker
        toolBar()
        self.tabBarController?.tabBar.isHidden = true
        textFieldSetup()
    }
    
    
    @IBAction func saveMealString(_ sender: Any) {
        mealString = mealQuantityView.text!
        mealTimeString = mealTimeTextView.text!
        mealContentString = mealContentTextView.text!
        
        let mealInfoArray:Dictionary = ["mealString": mealString as Any,"mealTimeString": mealTimeString as Any,"mealContentString": mealContentString as Any] as [String:Any]
        
            
        print(mealString!)
        print(mealTimeString!)
        print(mealContentString!)
        let uid = Auth.auth().currentUser?.uid

        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId!)
        aDog.collection("mealInfomation").addDocument(data: mealInfoArray)
        print(uid!,"meal登録できてる")
        print(dogId!,"meal登録できてる")
        self.performSegue(withIdentifier: "FinishedMeal", sender: nil)
        
    }
    
    @objc func dateChange(){
           let formatter = DateFormatter()
           formatter.dateFormat = "MM月dd日 HH時mm分"
        mealTimeTextView.text = "\(formatter.string(from: datePicker.date))"
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        mealTimeTextView.inputAccessoryView = toolBar
    }
    
     @objc func done(){
        mealQuantityView.endEditing(true)
    }

    func textFieldSetup(){
        setTexField.setPuTextField(setText: mealQuantityView)
        setTexField.setPuTextField(setText: mealTimeTextView)
        setTexField.setPuTextField(setText: mealContentTextView)
        
        //SaveButtonの設定も行う
        saveButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowRadius = 0.2
    }
}
