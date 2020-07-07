//
//  CalendarViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import AudioToolbox
import FSCalendar
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore



extension UILabel {
    func addBorderTop(height: CGFloat, color: UIColor) {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: height)//Labelの左上を起点として考える
        //yは縦方向なので上部に線をつけたければ0、下線をつけたければyを self.frame.height - heightで高さが引かれるので、Labelの左下に線をつけたければ起点が左下になり一番下に下線が引かれる
        
        topBorder.backgroundColor = color.cgColor
        self.layer.addSublayer(topBorder)
    }
}



class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var calender: FSCalendar!
    
    @IBOutlet var DayView: UIView!
    
    
    @IBOutlet var dayDate: UILabel!
    
    @IBOutlet var scheduleTableView: UITableView!
    
    var selectedDay: String?
    
    var selectedDayId: String?
    
    var scheduleContentArray = [ScheduleContent]()
    
    let deleteVC = deleteCollection()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NavigationControllerSetting
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes
        = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
           .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87) //戻るボタンなどの色
        
        //TabBar設定
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBarController?.tabBar.layer.shadowRadius = 4.0
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.6
        self.tabBarController?.tabBar.clipsToBounds = true
        
        //Calenderを縦スクロールに(横も可能)
        self.calender.scrollDirection = .vertical
        self.calender.layer.shadowColor = UIColor.clear.cgColor
        self.calender.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.calender.layer.shadowOpacity = 0
        self.calender.layer.shadowRadius = 0
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self

        //DayView下部の影設定(マテリアルデザインの階層を意識)
        DayView.layer.shadowColor = UIColor.gray.cgColor
        DayView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        DayView.layer.shadowRadius = 1
        DayView.layer.shadowOpacity = 0.1
        self.view.addSubview(DayView)
      
        
        todayDate()
        
        //選択している日付の色指定
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        //register()の引数に渡す定数「nib」を定義
        scheduleTableView.register(nib, forCellReuseIdentifier: "schedulTextCell")
        
        
        //Calendar予定追加ボタン
        let addButton = UIButton(type: .system)
        addButton.semanticContentAttribute = .forceRightToLeft
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.tintColor = UIColor.white
        addButton.addTarget(self, action: #selector(addSchedule), for: .touchUpInside)
        let addScheduleButton = UIBarButtonItem.init(customView: addButton)
        navigationItem.rightBarButtonItem = addScheduleButton
        addButton.frame = CGRect(x: self.view.frame.size.width/11, y:0, width: self.view.frame.size.width/11, height: self.view.frame.size.width/11)
        addButton.layer.cornerRadius = addButton.frame.size.height/2
        addButton.layer.backgroundColor =  UIColor(red: 247/255, green: 136/255, blue: 164/255, alpha: 1).cgColor
        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        addButton.layer.shadowOpacity = 0.6
        addButton.layer.shadowRadius = 1
        
        addButton.clipsToBounds = false
    }
    
    
    
      override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //以下カレンダー内の曜日表示設定
        self.calender.appearance.headerDateFormat = "YYYY年MM月"
        self.calender.calendarWeekdayView.weekdayLabels[0].text = "日" //Sunday
        self.calender.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calender.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calender.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calender.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calender.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calender.calendarWeekdayView.weekdayLabels[6].text = "土" //Saturday
    }
    
    
    
    
    //カレンダー上の日付をタップした時
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        dayDate.text = "\(year)年\(month)月\(day)日"
        
        //FIrestoreからクエリする為の日付を用意
        let selectDay = dayDate.text
        //日付が変わったらその都度UserDefaultsに保存
        UserDefaults.standard.set(selectDay, forKey: "selectedDay")
        print(selectDay!,"です！")
        
        //日付が選択されたらその日付がFirestore上にTimestampで保存されているか確認する。
        let uid = Auth.auth().currentUser?.uid
        let fetchScheduleInfo =  Firestore.firestore().collection("user").document(uid!).collection("scheduleList").whereField("scheduleDate", isEqualTo: selectDay!)
                fetchScheduleInfo.addSnapshotListener { snapShot, err in
                           guard let documents = snapShot?.documents else {
                                print("snapShotがerrですよ！")
                                return
                            }
                    //カレンダーの日付がタップされた時、他のタップられた日付の予定を表示させないためにScheduleを初期化しなければならない
                    self.scheduleContentArray = []
                                for snap in documents {
                                    if let postData = snap.data() as? [String: Any]{
                                        self.selectedDayId = snap.documentID
                                        //String型で保存していたものを取り出す
                                        let titleString = postData["scheduletitle"] as? String
                                        let startString = postData["scheduleStartTimeString"] as? String
                                        let endString = postData["scheduleEndTimeString"] as? String
                                        let contentString = postData["scheduleContent"] as? String
                                        let colorString = postData["scheduleCilorString"] as? String
                                        print(startString!)
                                        print(endString!)
                                        print(contentString!)
                                        print(self.selectedDayId!)
                                        
                                        self.scheduleContentArray.append(ScheduleContent(titleString: titleString!, startString: startString!, endString: endString!, contentString: contentString!, documentId: self.selectedDayId!, colorString: colorString!))
                                }
                            }
                    self.scheduleTableView.reloadData()
        }
    }
    
    //今日の日付けを呼んでくる
    func todayDate() {
        let date = Date()
        let calendar = Calendar.current
        let todayYear = calendar.component(.year, from: date)
        let todayMonth = calendar.component(.month, from: date)
        let today = calendar.component(.day, from: date)
        dayDate.text = "\(todayYear)年\(todayMonth)月\(today)日"
        selectedDay = dayDate.text!
        print(selectedDay!,"今日の日付")
        UserDefaults.standard.set(selectedDay, forKey: "selectedDay")
    }
    
    //予定追加画面での端末振動
    @IBAction func tapVibration(_ sender: Any) {
        //タップ時振動するように！
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
        }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    //スケジュールの追加ボタン
    @objc func addSchedule(){
        self.performSegue(withIdentifier: "toAddSchedule", sender: nil)
      }
    
    //以下TableViewの設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 143
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleContentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ScheduleCell = scheduleTableView.dequeueReusableCell(withIdentifier: "schedulTextCell", for: indexPath) as! TableViewCell
        ScheduleCell.awakeFromNib()
        
        //予定のタイトル
        let scheduleTitleLabel = ScheduleCell.viewWithTag(1) as! UILabel
        scheduleTitleLabel.text = scheduleContentArray[indexPath.row].scheduleTitleString
        //予定が始まる時間
        let scheduleStartLabel = ScheduleCell.viewWithTag(2) as! UILabel
        scheduleStartLabel.text = scheduleContentArray[indexPath.row].scheduleStartTimeString
        //予定が終わる時間
        let scheduleEndLabel = ScheduleCell.viewWithTag(3) as! UILabel
        scheduleEndLabel.text = scheduleContentArray[indexPath.row].scheduleEndTimeString
        //予定の内容
        let scheduleContentLabel = ScheduleCell.viewWithTag(4) as! UILabel
        scheduleContentLabel.text = scheduleContentArray[indexPath.row].scheduleContentString
        //色の設定
        let color = scheduleContentArray[indexPath.row].scheduleSelectedColor
        print(color, "色呼ばれてる！")
        let scheduleMainColor = ScheduleCell.viewWithTag(5) as! UILabel
        let scheduleBaseColor = ScheduleCell.cellView
        
            switch color {
              case "red":
                scheduleMainColor.backgroundColor = UIColor(red: 255/255, green: 104/255, blue:10/255, alpha: 1)
                scheduleBaseColor!.backgroundColor = UIColor(red: 255/255, green: 217/255, blue:194/255, alpha: 1)
              case "blue":
                 scheduleMainColor.backgroundColor = UIColor(red: 75/255, green: 171/255, blue:231/255, alpha: 1)
                 scheduleBaseColor!.backgroundColor = UIColor(red: 219/255, green: 238/255, blue:250/255, alpha: 1)
              case "yellow":
                 scheduleMainColor.backgroundColor = UIColor(red: 253/255, green: 231/255, blue: 76/255, alpha: 1)
                 scheduleBaseColor!.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1)
              case "green":
                 scheduleMainColor.backgroundColor = UIColor(red: 136/255, green: 183/255, blue: 181/255, alpha: 1)
                 scheduleBaseColor!.backgroundColor = UIColor(red: 242/255, green: 247/255, blue: 243/255, alpha: 1)
            default:
                scheduleMainColor.backgroundColor = UIColor(red: 255/255, green: 104/255, blue:10/255, alpha: 1)
                scheduleBaseColor?.backgroundColor = UIColor(red: 255/255, green: 217/255, blue:194/255, alpha: 1)
            }
        return ScheduleCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let storybordA: UIStoryboard = UIStoryboard(name: "ProfileInput", bundle: nil)
        
        let scheduleInfomation = scheduleContentArray[indexPath.row]
        //セルをタップしたときにプロフィール表示に必要な情報(文字列を保存する)
        UserDefaults.standard.set(scheduleInfomation.scheduleTitleString, forKey: "ScheduleTitleString")
        UserDefaults.standard.set(scheduleInfomation.scheduleStartTimeString, forKey: "ScheduleStartTimeString")
        UserDefaults.standard.set(scheduleInfomation.scheduleEndTimeString, forKey: "scheduleEndTimeString")
        UserDefaults.standard.set(scheduleInfomation.scheduleContentString, forKey: "scheduleContentString")
        UserDefaults.standard.set(scheduleInfomation.scheduleDocumentId, forKey: "scheduleDocumentId")
        let documentID = scheduleInfomation.scheduleDocumentId 
        
        //AlertInstance
        let editScheduleAlert: UIAlertController =
            UIAlertController(title: "スケジュール編集", message: "スケジュールを変更しますか？", preferredStyle: UIAlertController.Style.alert)
          
        
        //AlertAction
        let editScheduleAction: UIAlertAction = UIAlertAction(title: "削除する", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) -> Void in
            
            let db =  Firestore.firestore().collection("user").document(uid!).collection("scheduleList").document(documentID as! String)
                                   db.delete() { err in
                                       if let err = err {
                                           print("Error removing document: \(err)")
                                       } else {
                                           print("スケジュール削除")
                                   }
                               }
            
            tableView.reloadData()
            editScheduleAlert.dismiss(animated: true, completion: nil)
        })
        
        
        //CancelAction
        let editScheduleCancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
              // ボタンが押された時の処理を書く（クロージャです）
              (action: UIAlertAction!) -> Void in
            editScheduleAlert.dismiss(animated: true, completion: nil)
              print("Cancel")
          })
        
        editScheduleAlert.addAction(editScheduleAction)
        editScheduleAlert.addAction(editScheduleCancel)
        present(editScheduleAlert, animated: true, completion: nil)
    }
}
