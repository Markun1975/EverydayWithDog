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
    
    var timer:Timer!
    
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
    
    let warningAlert = warningAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        drinkTimeTextView.inputView = datePicker
        //数字のみ入力Keybord指定
        self.drinkQuantityView.keyboardType = UIKeyboardType.numberPad
        toolBar()
        self.tabBarController?.tabBar.isHidden = true
        saveButtonSetup()
    }
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        drinkTimeTextView.inputAccessoryView = toolBar
        drinkPlaceView.inputAccessoryView = toolBar
        drinkQuantityView.inputAccessoryView = toolBar
    }
    
    @objc func done(){
        drinkTimeTextView.endEditing(true)
        drinkPlaceView.endEditing(true)
        drinkQuantityView.endEditing(true)
    }
    
    @IBAction func saveWaterString(_ sender: Any) {
        waterString = drinkQuantityView.text!
        drinkTimeString = drinkTimeTextView.text!
        drinkPlaceString = drinkPlaceView.text!
        
        if drinkTimeString == nil || drinkTimeString == "" {

                present(warningAlert, animated: true)
            
            } else {
        
        let waterInfoArray:Dictionary = ["waterString": waterString as Any,"drinkTimeString": drinkTimeString as Any,"drinkPlaceString": drinkPlaceString as Any] as [String:Any]
            
        print(waterString!+"ml")
        print(drinkTimeString!)
        print(drinkPlaceString!)
        let uid = Auth.auth().currentUser?.uid
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId!)
        aDog.collection("waterInfomation").addDocument(data: waterInfoArray)
        
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
              formatter.dateFormat = "MM月dd日 HH時mm分"
           drinkTimeTextView.text = "\(formatter.string(from: datePicker.date))"
          }
    
    @objc func backToConditionView(){
           self.dismiss(animated: true, completion: nil)
    }
}
