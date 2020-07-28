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

class ToiletViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    @IBOutlet var toiletTimeView: UITextField!
    
    @IBOutlet var toiletPlaceView: UITextField!
    
    @IBOutlet var toiletTypeView: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    var timer:Timer!
    
    let setTexField = InputTextField()
    
    let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
       datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
       datePicker.locale = Locale(identifier: "ja_JP")
       datePicker.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker}()
    
        //トイレのタイプピッカー
        let typePikerView: UIPickerView = UIPickerView()
        let toiletType = ["小","大"]
    
       var dogId:String?
       var toiletTimeString: String?
       var drinkimeData: UIDatePicker = UIDatePicker()
       var toitelPlaceString: String?
       var toiletTypeString: String?
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        saveButtonSetup()
        toiletTimeView.inputView = datePicker
        toiletTypePikerSetup()
        toolBar()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func toolBar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spaceItem, doneItem], animated: true)
        toiletPlaceView.inputAccessoryView = toolBar
        toiletTimeView.inputAccessoryView = toolBar
        toiletTypeView.inputAccessoryView = toolBar
        
    }
    
    @IBAction func saveWalkInfo(_ sender: Any) {
        toiletTimeString = toiletTimeView.text!
        toitelPlaceString = toiletPlaceView.text!
        toiletTypeString = toiletTypeView.text!
        
        let toiletInfoArray:Dictionary = ["toiletTimeString": toiletTimeString as Any,"toitelPlaceString": toitelPlaceString as Any,"toiletTypeView": toiletTypeString as Any] as [String:Any]
            
        print(toiletTimeString!)
        print(toitelPlaceString!)
        let uid = Auth.auth().currentUser?.uid
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogId!)
        aDog.collection("toiletInfomation").addDocument(data: toiletInfoArray)
        self.performSegue(withIdentifier: "FinishToilet", sender: nil)
        
        //登録完了のポップアップを出す
        let storyBoard: UIStoryboard = self.storyboard!
        
        let popupView = storyBoard.instantiateViewController(withIdentifier: "EndInputConditionView")
        popupView.modalPresentationStyle = .overFullScreen
        popupView.modalTransitionStyle = .crossDissolve
        self.present(popupView, animated: true, completion: nil)
        //二秒後にTop画面へ繊維
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(backToConditionView), userInfo: nil, repeats: false)
    }
    
    //以下各入力フォームの設定
    func saveButtonSetup(){
        saveButton.layer.cornerRadius = 5
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowRadius = 0.2
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
    
    func toiletTypePikerSetup(){
        typePikerView.delegate = self
        typePikerView.dataSource = self
        toiletTypeView.inputView = typePikerView
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return toiletType[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toiletType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            self.toiletTypeView.text = "小"
        case 1:
            self.toiletTypeView.text = "大"
        default:
            break
        }
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH時mm分"
         toiletTimeView.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @objc func done(){
        toiletTimeView.endEditing(true)
        toiletPlaceView.endEditing(true)
        toiletTypeView.endEditing(true)
    }
    
    @objc func backToConditionView(){
           self.dismiss(animated: true, completion: nil)
    }
    
}

