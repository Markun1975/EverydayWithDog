//
//  ToiletViewController.swift
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

class ToiletViewController: UIViewController {
    
    @IBOutlet var toiletTimeView: UITextField!
    
    @IBOutlet var toiletPlaceView: UITextField!
    
    @IBOutlet var ToiletTypeView: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
       datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
       datePicker.locale = Locale(identifier: "ja_JP")
           datePicker.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker}()
       
       var toiletTimeString: String?
       var drinkimeData: UIDatePicker = UIDatePicker()
       var toitelPlaceString: String?
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toiletTimeView.inputView = datePicker
        toolBar()
        self.tabBarController?.tabBar.isHidden = true
        textFieldSetup()
    }
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        toiletPlaceView.inputAccessoryView = toolBar
    }
    
    @objc func dateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH時mm分"
         toiletTimeView.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @objc func done(){
        toiletPlaceView.endEditing(true)
    }
    
    
    @IBAction func saveWalkInfo(_ sender: Any) {
        toiletTimeString = toiletTimeView.text!
        toitelPlaceString = toiletPlaceView.text!
        
//        let toiletTimestamp = Timestamp.init(date: datePicker.date)
        
        let toiletInfoArray:Dictionary = ["toiletTimeString": toiletTimeString as Any,"toitelPlaceString": toitelPlaceString as Any] as [String:Any]
            
        print(toiletTimeString!)
        print(toitelPlaceString!)
        let uid = Auth.auth().currentUser?.uid
        let dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId as! String)
        aDog.collection("toiletInfomation").addDocument(data: toiletInfoArray)
        self.performSegue(withIdentifier: "FinishToilet", sender: nil)
    }
    
    //以下各入力フォームの設定
    func textFieldSetup(){
          
           toiletTimeView.layer.cornerRadius = 6
           toiletTimeView.layer.borderWidth = 0.8
           
          
           toiletPlaceView.layer.cornerRadius = 6
           toiletPlaceView.layer.borderWidth = 0.8
           
        
           ToiletTypeView.layer.cornerRadius = 6
           ToiletTypeView.layer.borderWidth = 0.8
           
           saveButton.layer.cornerRadius = 5
       }
}

