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
    
    @IBOutlet var walkTimeView: UITextField!
    
    @IBOutlet var wakePlaceTextView: UITextField!
    
    @IBOutlet var walkDistanceView: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    var timer:Timer!
    
    let warningAlert = warningAlertController()
    
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
       var walkTimeString:String?
//       var endTimeString: String?
       var walkPlaceString: String?
       var walkDistanceStirng: String?
    
    let checkAlert = warningAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        walkStartTimeView.inputView = datePicker1
        walkTimeView.inputView = datePicker2
        contentsClass.contentsTextView = wakePlaceTextView
        //数字のみ入力Keybord指定
        self.walkDistanceView.keyboardType = UIKeyboardType.numberPad
        contentsClass.toolBar()
        saveButtonSetup()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        walkStartTimeView.inputAccessoryView = toolBar
        walkTimeView.inputAccessoryView = toolBar
        wakePlaceTextView.inputAccessoryView = toolBar
        walkDistanceView.inputAccessoryView = toolBar
    }
    
    
    @IBAction func saveWalkInfo(_ sender: Any) {
        startTimeString = walkStartTimeView.text!
        walkTimeString = walkTimeView.text!
        walkPlaceString = wakePlaceTextView.text!
        walkDistanceStirng = walkDistanceView.text!
        
        
        if startTimeString == nil || startTimeString == "" || walkTimeString == nil || walkTimeString == "" {
            
        present(warningAlert, animated: true)
        } else {
        //散歩時間を入力値の差分で計算し、保存する
        let d1 = datePicker1.date
        let d2 = datePicker2.date
            
//        datePicker2.minimumDate = d1
//        datePicker2.maximumDate = d1.addingTimeInterval(60 * 60 * 6)
//
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
            
        let diff = d2.timeIntervalSince(d1) + 60
        let timeFmt = DateComponentsFormatter()
        timeFmt.unitsStyle = .brief
        //秒数を表示させないため、HH時mm分表記にする
        timeFmt.allowedUnits = [.hour, .minute]
        //秒数を時間分に変換
//        timeFormatter.string(from: diff)
        let walkTime = timeFmt.string(from: diff)
        print(diff,"これが時間差なので注目してください!!!!")
        
            guard diff > 0 else {
                let timeWarningAlert = UIAlertController(title: "エラー", message: "終了時間が開始時間より前の場合、記録が残せません。", preferredStyle: UIAlertController.Style.alert)
                
                    let checkOKAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                        timeWarningAlert.dismiss(animated: true, completion: nil)
                        }

                        timeWarningAlert.addAction(checkOKAction)
                        present(timeWarningAlert, animated: true)
                return
            }
        
        let walkInfoArray:Dictionary = ["walkTime": walkTime as Any,"walkPlaceString": walkPlaceString as Any,"startTimeString": startTimeString as Any,"walkDistanceStirng":walkDistanceStirng as Any] as [String:Any]
        
        let uid = Auth.auth().currentUser?.uid
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId!)
        aDog.collection("walkInfomation").addDocument(data: walkInfoArray)
        
        //登録完了のポップアップを出す
        let storyBoard: UIStoryboard = self.storyboard!
        
        let popupView = storyBoard.instantiateViewController(withIdentifier: "EndInputConditionView")
        popupView.modalPresentationStyle = .overFullScreen
        popupView.modalTransitionStyle = .crossDissolve
        self.present(popupView, animated: true, completion: nil)
        //二秒後にTop画面へ繊維
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(backToConditionView), userInfo: nil, repeats: false)
        }
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
    
    
        func saveButtonSetup(){
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
    
    @objc func dateChange(){
        let formatter = DateFormatter()
        let timeFormatter = DateFormatter()
        formatter.dateFormat = "MM月dd日HH時mm分"
        walkStartTimeView.text = "\(formatter.string(from: datePicker1.date))"
        timeFormatter.dateFormat = "HH時mm分"
        walkTimeView.text = "\(timeFormatter.string(from: datePicker2.date))"
        //入力日時を限定する
        datePicker2.minimumDate = datePicker1.date
        datePicker2.maximumDate = datePicker1.date.addingTimeInterval(60 * 60 * 6)
    }

    @objc func done(){
        walkStartTimeView.endEditing(true)
        walkTimeView.endEditing(true)
        wakePlaceTextView.endEditing(true)
        walkDistanceView.endEditing(true)
    }
    
    @objc func backToConditionView(){
           self.dismiss(animated: true, completion: nil)
    }
    
    
}
