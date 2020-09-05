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
    
    var timer:Timer!
    
    var warningAlert = warningAlertController()
    
    let setTexField = InputTextField()
    
        var dogId:String?
        var mealString: String?
        var mealTimeData: UIDatePicker = UIDatePicker()
//        var mealTimeString: String?
          var mealTimeString = ""
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
        //数字のみ入力Keybord指定
        self.mealQuantityView.keyboardType = UIKeyboardType.numberPad
        saveButtonSetup()
    }
    
    
    @IBAction func saveMealString(_ sender: Any) {
        mealString = mealQuantityView.text!
        mealTimeString = mealTimeTextView.text!
        mealContentString = mealContentTextView.text!
        
        if mealTimeString == nil || mealTimeString == "" {
            //Alertを出す
            present(warningAlert, animated: true)
        } else {
        
        let mealInfoArray:Dictionary = ["mealString": mealString as Any,"mealTimeString": mealTimeString as Any,"mealContentString": mealContentString as Any] as [String:Any]
        
            
        print(mealString!)
        print(mealTimeString)
        print(mealContentString!)
        let uid = Auth.auth().currentUser?.uid

        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId!)
        aDog.collection("mealInfomation").addDocument(data: mealInfoArray)
        print(uid!,"meal登録できてる")
        print(dogId!,"meal登録できてる")
        
        //登録完了のポップアップを出す
        let storyBoard: UIStoryboard = self.storyboard!
        
        let popupView = storyBoard.instantiateViewController(withIdentifier: "EndInputConditionView")
        popupView.modalPresentationStyle = .overFullScreen
        popupView.modalTransitionStyle = .crossDissolve
        self.present(popupView, animated: true)
        
        //二秒後にTop画面へ繊維
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(backToConditionView), userInfo: nil, repeats: false)
        }
    }
    
    @objc func dateChange(){
           let formatter = DateFormatter()
           formatter.dateFormat = "MM月dd日 HH時mm分"
        mealTimeTextView.text = "\(formatter.string(from: datePicker.date))"
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる
            self.view.endEditing(true)
    }
    
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        mealQuantityView.inputAccessoryView = toolBar
        mealTimeTextView.inputAccessoryView = toolBar
        mealContentTextView.inputAccessoryView = toolBar
    }

    func saveButtonSetup(){
        //SaveButtonの設定も行う
        saveButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowRadius = 0.2
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done(){
        mealQuantityView.endEditing(true)
        mealTimeTextView.endEditing(true)
        mealContentTextView.endEditing(true)
    }
    
    @objc func backToConditionView(){
        self.dismiss(animated: true, completion: nil)
    }
}
