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
    
    let setTexField = InputTextField()
    
    //開始日時
    let datePicker1: UIDatePicker = {
       let datePicker = UIDatePicker()
       datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
       datePicker.locale = Locale(identifier: "ja_JP")
           datePicker.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker}()
    
    //終了日時
       let datePicker2: UIDatePicker = {
          let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.time
          datePicker.locale = Locale(identifier: "ja_JP")
              datePicker.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker}()
       var dogId:String?
       var startTimeString: String?
       var drinkimeData: UIDatePicker = UIDatePicker()
       var endTimeString: String?
       var walkPlaceString: String?
       var walkDistanceStirng: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        walkStartTimeView.inputView = datePicker1
        walkEndTimeView.inputView = datePicker2
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
        let timeFormatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH時mm分"
        timeFormatter.dateFormat = "HH時mm分"
        walkStartTimeView.text = "\(formatter.string(from: datePicker1.date))"
        walkEndTimeView.text = "\(timeFormatter.string(from: datePicker2.date))"
        
       
        
        
    }

    @objc func done(){
        wakePlaceTextView.endEditing(true)
    }
    
    
    @IBAction func saveWalkInfo(_ sender: Any) {
        startTimeString = walkStartTimeView.text!
        endTimeString = walkEndTimeView.text!
        walkPlaceString = wakePlaceTextView.text!
        walkDistanceStirng = walkDistanceView.text!
        
        //散歩時間を入力値の差分で計算し、保存する
        let d1 = datePicker1.date
        let d2 = datePicker2.date
        let diff = d2.timeIntervalSince(d1)
        let timeFmt = DateComponentsFormatter()
        timeFmt.unitsStyle = .brief
        //秒数を時間分に変換
        let walkTime = timeFmt.string(from: diff)
        print(walkTime!)
        
        
        let walkInfoArray:Dictionary = ["walkTime": walkTime as Any,"walkPlaceString": walkPlaceString as Any,"startTimeString": startTimeString as Any,"walkDistanceStirng":walkDistanceStirng as Any] as [String:Any]
        
        let uid = Auth.auth().currentUser?.uid
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId!)
        aDog.collection("walkInfomation").addDocument(data: walkInfoArray)
        self.performSegue(withIdentifier: "FinishedWalk", sender: nil)
    }
    
        func textFieldSetup(){
            setTexField.setPuTextField(setText: walkStartTimeView)
            setTexField.setPuTextField(setText: walkEndTimeView)
            setTexField.setPuTextField(setText: wakePlaceTextView)
            setTexField.setPuTextField(setText: walkDistanceView)
            saveButton.layer.cornerRadius = 5
            saveButton.layer.cornerRadius = 5
            saveButton.layer.shadowColor = UIColor.black.cgColor
            saveButton.layer.shadowOffset = CGSize(width: 0, height: 1)
            saveButton.layer.shadowOpacity = 0.2
            saveButton.layer.shadowRadius = 0.2
        }
    
}
