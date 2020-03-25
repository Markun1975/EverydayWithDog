//
//  WalkViewController.swift
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

class WalkViewController: UIViewController {
    
    let contentsClass = TimeManagement()
    
    @IBOutlet var walkStartTimeView: UITextField!
    
    @IBOutlet var walkEndTimeView: UITextField!
    
    @IBOutlet var wakePlaceTextView: UITextField!
    
    @IBOutlet var walkDistanceView: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    
    let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
       datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
       datePicker.locale = Locale(identifier: "ja_JP")
           datePicker.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker}()
       
       var startTimeString: String?
       var drinkimeData: UIDatePicker = UIDatePicker()
       var endTimeString: String?
       var walkPlaceString: String?
       var walkDistanceStirng: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkStartTimeView.inputView = datePicker
        walkEndTimeView.inputView = datePicker
        contentsClass.contentsTextView = wakePlaceTextView
        contentsClass.toolBar()
        textFieldSetup()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        wakePlaceTextView.inputAccessoryView = toolBar
    }
    
    @objc func dateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH時mm分"
        walkStartTimeView.text = "\(formatter.string(from: datePicker.date))"
        walkEndTimeView.text = "\(formatter.string(from: datePicker.date))"
    }

    @objc func done(){
        wakePlaceTextView.endEditing(true)
    }
    
    
    @IBAction func saveWalkInfo(_ sender: Any) {
        startTimeString = walkStartTimeView.text!
        endTimeString = walkEndTimeView.text!
        walkPlaceString = wakePlaceTextView.text!
        walkDistanceStirng = walkDistanceView.text!
        
        let walkInfoArray:Dictionary = ["walkPlaceString": walkPlaceString as Any,"startTimeString": startTimeString as Any,"endTimeString": endTimeString as Any,"walkDistanceStirng":walkDistanceStirng as Any] as [String:Any]
            
        print(walkPlaceString!)
        print(startTimeString!)
        print(endTimeString!)
        print(walkDistanceStirng!)
        let uid = Auth.auth().currentUser?.uid
        let dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId as! String)
        aDog.collection("walkInfomation").addDocument(data: walkInfoArray)
        self.performSegue(withIdentifier: "FinishedWalk", sender: nil)
    }
    
        func textFieldSetup(){
            walkStartTimeView.layer.cornerRadius = 6
            walkStartTimeView.layer.borderWidth = 0.8
            
            walkEndTimeView.layer.cornerRadius = 6
            walkEndTimeView.layer.borderWidth = 0.8
            
            wakePlaceTextView.layer.cornerRadius = 6
            wakePlaceTextView.layer.borderWidth = 0.8
            
            walkDistanceView.layer.cornerRadius = 6
            walkDistanceView.layer.borderWidth = 0.8
            
            saveButton.layer.cornerRadius = 5
        }
}
