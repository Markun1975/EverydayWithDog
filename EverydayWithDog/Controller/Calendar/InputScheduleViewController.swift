//
//  InputScheduleViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 2/16/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class DateFormat {
    
    class func deteFormatString(string: String, format: String) -> Date {
    let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
}
    



class InputScheduleViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var scheduleTitletext: UITextField!
    
    @IBOutlet var scheduleStartText: UITextField!
    
    @IBOutlet var scheduleEndText: UITextField!
    
    @IBOutlet var selectedDayLabel: UILabel!
    
    @IBOutlet var waveLabel: UILabel!
    
    @IBOutlet var redButton: UIButton!
    
    @IBOutlet var blueButton: UIButton!
    
    @IBOutlet var yellowButton: UIButton!
    
    @IBOutlet var scheduleContentsView: UITextField!
    
    @IBOutlet var greenButton: UIButton!
    
//    @IBOutlet var mapButton: UIButton!
    
    @IBOutlet var saveButton: UIButton!
    
    let setTexField = InputTextField()
    
    let saveMethod = ScheduleObject()
    
    let titleColor = CGColor(srgbRed: 81, green: 178, blue: 255, alpha: 100)
    
    
    
    let datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    //日付ありきか時間のみか
    datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
//        datePicker.datePickerMode = UIDatePicker.Mode.time
    datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker}()
    
    let datePicker2: UIDatePicker = {
    let datePicker2 = UIDatePicker()
        datePicker2.datePickerMode = UIDatePicker.Mode.time
    datePicker2.locale = Locale(identifier: "ja_JP")
    datePicker2.addTarget(self, action:#selector(dateChange), for: .valueChanged); return datePicker2}()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        textFieldSetup()
//        mapButtonSetUp()
        saveButton.layer.cornerRadius = 5
        setpuColorButton(setButton: redButton)
        setpuColorButton(setButton: blueButton)
        setpuColorButton(setButton: yellowButton)
        setpuColorButton(setButton: greenButton)
        scheduleTitletext.delegate = self as? UITextFieldDelegate
        scheduleStartText.delegate = self as? UITextFieldDelegate
        scheduleEndText.delegate = self as?  UITextFieldDelegate
        scheduleContentsView.delegate = self as?  UITextFieldDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDay()
    }
    
    
    @objc func dateChange(){
           let formatter = DateFormatter()
           formatter.timeStyle = .short
           formatter.dateFormat = "HH:mm"
           scheduleStartText.text = "\(formatter.string(from: datePicker.date))"
           scheduleEndText.text = "\(formatter.string(from: datePicker2.date))"
        
           let simpleFormatter = DateFormatter()
        //scheduleの日付を変えたら自動的にラベルも変わる
          if scheduleStartText.text != nil {
            simpleFormatter.dateStyle = .long
            simpleFormatter.locale = Locale(identifier: "ja_JP")
            selectedDayLabel.text = "\(simpleFormatter.string(from: datePicker.date))"
//            scheduleEndText.text = "\(simpleFormatter.string(from: datePicker.date))"
          }else{
            return
        }
       }

    @IBAction func saveSchedule(_ sender: Any) {
        saveObject()
    }
    
    
    func saveObject() {
        saveMethod.title = scheduleTitletext.text!
        saveMethod.startString = scheduleStartText.text!
        saveMethod.endString = scheduleEndText.text!
        saveMethod.contentsString = scheduleContentsView.text!
        saveMethod.scheduleDateString = selectedDayLabel.text!
        saveMethod.selectedColor = UserDefaults.standard.object(forKey: "colorString") as! String
        
        if saveMethod.selectedColor == nil {
            saveMethod.selectedColor = "red"
        }
        
        saveMethod.saveScheduleObject()
        
        let scheduleInfoArray:Dictionary = ["scheduletitle": saveMethod.title as Any,"scheduleStartTimeString": saveMethod.startString as Any,"scheduleEndTimeString": saveMethod.endString as Any,"scheduleContent": saveMethod.contentsString as Any,"scheduleCilorString": saveMethod.selectedColor,"scheduleDateTimestamp": Timestamp(date: datePicker.date) as Any,"scheduleDate": saveMethod.scheduleDateString] as [String:Any]
                   
               let uid = Auth.auth().currentUser?.uid
               let dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("scheduleList")
            aDog.addDocument(data: scheduleInfoArray)
    }
    
    private func textFieldSetup(){
        self.waveLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        
        setTexField.setPuTextField(setText: scheduleTitletext)
        
        setTexField.setPuTextField(setText: scheduleStartText)
        scheduleStartText.inputView = datePicker
        
        setTexField.setPuTextField(setText: scheduleEndText)
        scheduleEndText.inputView = datePicker2
        
        setTexField.setPuTextField(setText: scheduleContentsView)
        
        view.addSubview(scheduleStartText)
        view.addSubview(scheduleEndText)
    }
    
    
    func fetchDay(){
      let selectDay = UserDefaults.standard.object(forKey: "selectedDay") as! String
      selectedDayLabel.text = selectDay
      print(selectDay,"の予定を作成中！")
        
     let dateToPicker = DateFormat.deteFormatString(string: selectDay, format: "yyyy年MM月dd日")
     datePicker.date = dateToPicker
     datePicker2.date = dateToPicker
    }
    
    @IBAction func redAction(_ sender: Any) {
        saveButton.backgroundColor =  UIColor(red: 255/255, green: 104/255, blue:10/255, alpha: 1)
        UserDefaults.standard.set("red", forKey: "colorString")
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func blueAction(_ sender: Any) {
        saveButton.backgroundColor = UIColor(red: 75/255, green: 171/255, blue:231/255, alpha: 1)
        UserDefaults.standard.set("blue", forKey: "colorString")
        saveButton.setTitleColor(UIColor.white, for: .normal)
        }
    
    @IBAction func yellowAction(_ sender: Any) {
        saveButton.backgroundColor = UIColor(red: 253/255, green: 231/255, blue: 76/255, alpha: 1)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        UserDefaults.standard.set("yellow", forKey: "colorString")
    }
    
    @IBAction func greenAction(_ sender: Any) {
        saveButton.backgroundColor = UIColor(red: 136/255, green: 183/255, blue: 181/255, alpha: 1)
        UserDefaults.standard.set("green", forKey: "colorString")
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setpuColorButton(setButton: UIButton){
        var button = UIButton()
        button = setButton
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 0.2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scheduleTitletext.resignFirstResponder()
        scheduleStartText.resignFirstResponder()
        scheduleEndText.resignFirstResponder()
        scheduleContentsView.resignFirstResponder()
    }
    
    //GoogleMap検索機能を使用する際に必要（今後実装）
//    private func mapButtonSetUp(){
//          mapButton.layer.cornerRadius = 4
//          mapButton.layer.shadowColor = UIColor.black.cgColor
//          mapButton.layer.shadowOffset = CGSize(width: 2, height: 2)
//          mapButton.layer.shadowRadius = 2
//          mapButton.layer.shadowOpacity = 0.3
//          view.addSubview(mapButton)
//      }
    
}


