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


class InputScheduleViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var scheduleTitletext: UITextField!
    
    @IBOutlet var scheduleStartText: UITextField!
    
    @IBOutlet var scheduleEndText: UITextField!
    
    @IBOutlet var selectedDayLabel: UILabel!
    
    
    @IBOutlet var waveLabel: UILabel!
    
    @IBOutlet var scheduleContentsView: UITextField!
    
    @IBOutlet var mapButton: UIButton!
    
    @IBOutlet var saveButton: UIButton!
    
    
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
        mapButtonSetUp()
        saveButton.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let selectDay = UserDefaults.standard.object(forKey: "selectedDay") as! String
        selectedDayLabel.text = selectDay
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
        
        saveMethod.saveScheduleObject()
        
        let scheduleInfoArray:Dictionary = ["scheduletitle": saveMethod.title as Any,"scheduleStartTimeString": saveMethod.startString as Any,"scheduleEndTimeString": saveMethod.endString as Any,"scheduleContent": saveMethod.contentsString as Any,"scheduleDateTimestamp": Timestamp(date: datePicker.date) as Any,"scheduleDate": saveMethod.scheduleDateString] as [String:Any]
                   
               let uid = Auth.auth().currentUser?.uid
               let dogId = UserDefaults.standard.object(forKey: "dogID") as! String
        let aDog = Firestore.firestore().collection("user").document(uid!).collection("scheduleList")
            aDog.addDocument(data: scheduleInfoArray)
    }
    
    private func textFieldSetup(){
        
        self.waveLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        
        scheduleTitletext.layer.cornerRadius = 6
        scheduleTitletext.layer.borderWidth = 0.8
        scheduleTitletext.layer.borderColor = UIColor.systemBlue.cgColor
        
        scheduleStartText.inputView = datePicker
        scheduleStartText.layer.cornerRadius = 6
        scheduleStartText.layer.borderWidth = 0.8
        
        scheduleEndText.inputView = datePicker2
        scheduleEndText.layer.cornerRadius = 6
        scheduleEndText.layer.borderWidth = 0.8
        
        scheduleContentsView.layer.cornerRadius = 6
        scheduleContentsView.layer.borderWidth = 0.8
        
        view.addSubview(scheduleTitletext)
        view.addSubview(scheduleStartText)
        view.addSubview(scheduleEndText)
        view.addSubview(scheduleContentsView)
    }
    
    private func mapButtonSetUp(){
        mapButton.layer.cornerRadius = 4
        mapButton.layer.shadowColor = UIColor.black.cgColor
        mapButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        mapButton.layer.shadowRadius = 2
        mapButton.layer.shadowOpacity = 0.3
        view.addSubview(mapButton)
    }
}
