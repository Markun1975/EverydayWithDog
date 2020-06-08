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
    
    @IBOutlet var dayDate: UILabel!
    
    @IBOutlet var scheduleTableView: UITableView!
    
    @IBOutlet var addButton: UIBarButtonItem!
    
    var selectedDay: String?
    
    
    
    var scheduleContentArray = [ScheduleContent]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        todayDate()
        
        //選択している日付の色指定
        dayDate.addBorderTop(height: 1.0, color: UIColor.lightGray)
        let nib = UINib(nibName: "TableViewCell", bundle: nil)  //register()の引数に渡す定数「nib」を定義
        scheduleTableView.register(nib, forCellReuseIdentifier: "schedulTextCell")
//        addButton.layer.cornerRadius = 9 //UIButtonの場合は角を丸める
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
        //日付の初期化
//        selectedDay = ""
        //開いたときに今日の日付を表示する
//        guard self.selectedDay != nil else {
//        todayDate()
//        return
//        }
        
        
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
        selectedDay = selectDay
        //日付が変わったらその都度UserDefaultsに保存
        UserDefaults.standard.set(selectDay, forKey: "selectedDay")
        print(selectDay!,"やで！")
        //縦スクロールに 横も可能
        calendar.scrollDirection = .vertical
        
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
                                        //String型で保存していたものを取り出す
                                        let titleString = postData["scheduletitle"] as? String
                                        let startString = postData["scheduleStartTimeString"] as? String
                                        let endString = postData["scheduleEndTimeString"] as? String
                                        let contentString = postData["scheduleContent"] as? String
                                        print(startString!)
                                        print(endString!)
                                        print(contentString!)
                                        
                                        self.scheduleContentArray.append(ScheduleContent(titleString: titleString!, startString: startString!, endString: endString!, contentString: contentString!))
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
//        UserDefaults.standard.set(selectedDay, forKey: "today")
        UserDefaults.standard.set(selectedDay, forKey: "selectedDay")
    }
    
    //予定追加
    @IBAction func tapVibration(_ sender: Any) {
        //タップ時振動するように！
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
        }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    
    
    
    
    //以下TableViewの設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 143
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleContentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "schedulTextCell", for: indexPath) as! TableViewCell
        
        //予定のタイトル
        let scheduleTitleLabel = cell.viewWithTag(1) as! UILabel
        scheduleTitleLabel.text = scheduleContentArray[indexPath.row].scheduleTitleString
        //予定が始まる時間
        let scheduleStartLabel = cell.viewWithTag(2) as! UILabel
        scheduleStartLabel.text = scheduleContentArray[indexPath.row].scheduleStartTimeString
        //予定が終わる時間
        let scheduleEndLabel = cell.viewWithTag(3) as! UILabel
        scheduleEndLabel.text = scheduleContentArray[indexPath.row].scheduleEndTimeString
        //予定の内容
        let scheduleContentLabel = cell.viewWithTag(4) as! UILabel
        scheduleContentLabel.text = scheduleContentArray[indexPath.row].scheduleContentString
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storybordA: UIStoryboard = UIStoryboard(name: "ProfileInput", bundle: nil)
        
        let scheduleInfomation = scheduleContentArray[indexPath.row]
        //セルをタップしたときにプロフィール表示に必要な情報(文字列を保存する)
        UserDefaults.standard.set(scheduleInfomation.scheduleTitleString, forKey: "ScheduleTitleString")
        UserDefaults.standard.set(scheduleInfomation.scheduleStartTimeString, forKey: "ScheduleStartTimeString")
        UserDefaults.standard.set(scheduleInfomation.scheduleEndTimeString, forKey: "scheduleEndTimeString")
        UserDefaults.standard.set(scheduleInfomation.scheduleContentString, forKey: "scheduleContentString")
        
        let scheduleVC = storybordA.instantiateViewController(withIdentifier: "profileView")
        self.present(scheduleVC, animated: true, completion: nil)
    }
    
}
