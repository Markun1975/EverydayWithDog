//
//  MealDataTableViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/16/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SegementSlide
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class MealDataTableViewController: UITableViewController,SegementSlideContentScrollViewDelegate {
    
    var mealInfoArray = [MealInfo]()
    
    public var dataVC = DogDataViewController()
    
    var dogID:String?
    var dogNAME:String?
    
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // サイドバーメニューからの通知を受け取る
            NotificationCenter.default.addObserver(
            self,selector: #selector(catchSelectMenuNotification(notification:)),name:Notification.Name("dogID"),object: nil)
            NotificationCenter.default.addObserver(
            self,selector: #selector(catchSelectNameNotification(notification:)),name: Notification.Name("dogNAME"),object: nil)
        print("viewDidLoad終了")
  }
    
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealInfoArray.count
    }
    
    //numberOfRowsInSectionの数だけセルが呼ばれる
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        //いつ食べたか時刻を表示
        cell.textLabel?.text = self.mealInfoArray[indexPath.row].mealTimeString
        cell.detailTextLabel?.text = self.mealInfoArray[indexPath.row].mealContentString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/10
    }
    
    //セルがタップされたときに画面遷移を行う
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear呼ばれた")
        fetchMealData()
    }
    
    func fetchMealData(){
        self.mealInfoArray.removeAll()
        guard self.dogID != nil else {
            //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
            let db =  Firestore.firestore().collection("user").document(uid!).collection("dogList").limit(to: 1)
            db.getDocuments() { snapShot, err in

                             guard let documents = snapShot?.documents else {
                                         print("snapShotがerrですよ！")
                                         return
                                 }
                                         for snap in documents {
                                             if let postData = snap.data() as? [String: Any]{

                                                let firstDogId = snap.documentID
                                                print(firstDogId,"初期のDOG　ID")
                                                self.dogID = firstDogId
                                                
                                                let firstDogName = postData["dogName"] as? String
                                                print(firstDogName!,"初期のDOG NAME")
//                                                self.dogNAME = firstDogName!
//                                                self.dataVC.dogNamelabel.text = firstDogName!
                             }
                                            self.loadMealInfo()
                         }
                     }
        return
    }
        loadMealInfo()
    }
    
 
    // 選択されたサイドバーのDogIDを取得
       @objc func catchSelectMenuNotification(notification: Notification) -> Void {
           // メニューからの返り値を取得
        self.dogID = notification.userInfo!["dogId"] as! String // 返り値が格納されている変数
        print(self.dogID! as Any, "MealでDogID変更取得できました")
    }
    
    // 選択されたサイドバーのDogNAMEを取得
       @objc func catchSelectNameNotification(notification: Notification) -> Void {
           // メニューからの返り値を取得
        self.dogNAME = (notification.userInfo!["dogName"] as! String) // 返り値が格納されている変数
        print(self.dogNAME! as Any, "MealでDogID変更取得できました")
        loadMealInfo()
    }
    
    
    
    
    func loadMealInfo() {
        let fetchMealInfo = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(self.dogID!).collection("mealInfomation")
               fetchMealInfo.getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                    //[]でmealInfoArrayを0にしておかないとセルが増えていくため、初期化する
                    self.mealInfoArray = []
                       for document in querySnapshot!.documents {
                           if let mealData = document.data() as? [String: Any] {
                                let mealString = mealData["mealString"] as? String
                               
                                let mealTimeString = mealData["mealTimeString"] as? String
                               
                                let mealContentString = mealData["mealContentString"] as? String
                               
                               self.mealInfoArray.append(MealInfo(mealString: mealString!, mealTimeString: mealTimeString!, mealContentString: mealContentString!))
                           }
                            //読み込みが終わったタイミングですぐにTableViewにリロードして反映
                                               self.tableView.reloadData()
                       }
                   }
               }
}
}
    


