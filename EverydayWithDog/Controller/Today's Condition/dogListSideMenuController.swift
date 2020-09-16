//
//  dogListSideMenu2Controller.swift
//  EverydayWithDog
//
//  Created by Masaki on 2/28/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//
import UIKit
import SideMenu
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

//サイドバーに犬リストを表示
class dogListSideMenuController: UITableViewController {
    
    var dogInfoArray = [SimpleDogInfo]()
    
    let uid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NavigationController設定
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 242/255, green: 87/255, blue: 129/255, alpha: 1)
        //NavigationBarの上にViewが出た時、NavigationBarを透明にするかどうか（透かして、下のNavigationBarの色に合わせるか）
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationItem.title = "ワンちゃん一覧"
        self.navigationController?.navigationBar.titleTextAttributes
        = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
           .foregroundColor: UIColor(red: 255, green: 255, blue: 255, alpha: 0.87)]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                  super.viewWillAppear(animated)
                  fetchDogData()
              }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogInfoArray.count
    }
    
    
    //numberOfRowsInSectionの数だけセルが呼ばれる
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
    //名前を表示
        cell.textLabel?.text = self.dogInfoArray[indexPath.row].nameString
        _ = self.dogInfoArray[indexPath.row].dogID
        
        _ = self.dogInfoArray[indexPath.row].nameString
        return cell
    }
    
    
    //セルがタップされたときに画面遷移を行う
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ID = self.dogInfoArray[indexPath.row].dogID
        let NAME = self.dogInfoArray[indexPath.row].nameString
        

        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // サイドバーを閉じる
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("dogID"), object: nil, userInfo: ["dogId" : ID])
        NotificationCenter.default.post(name: Notification.Name("dogNAME"), object: nil, userInfo: ["dogName" : NAME])
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDogData()
    }
    
    
    func fetchDogData() {
        //データベースから犬の情報を取得する　referenceする
        //インプット（登録ボタン）押したときに登録した、Key値("dogList")を使って情報を取得する
        let fetchDogInfo =  Firestore.firestore().collection("user").document(uid!).collection("dogList")
            fetchDogInfo.getDocuments() { snapShot, err in
                
            self.dogInfoArray.removeAll()
            guard let documents = snapShot?.documents else {
                print("snapShotがerrですよ！")
                return
            }
                for snap in documents {
                    if let postData = snap.data() as? [String: Any]{
                        
                        let dogID = snap.documentID
                        
                        //String型で保存していたものをFirebaseから取り出す
                        let nameData = postData["dogName"] as? String
                        let postDate:Timestamp? = postData["postDate"] as? Timestamp
                        
                        //postDate(Timestamp)を時間に変換する
                        let timeString = postDate?.dateValue()
                        let f = DateFormatter()
                            f.locale = Locale(identifier: "ja_JP")
                            f.dateStyle = .long
                            f.timeStyle = .none
                        let date = f.string(from: timeString!)
                        self.dogInfoArray.append(SimpleDogInfo(nameString: nameData!,inputDateString: date,dogID: dogID))
                }
                     self.tableView.reloadData()
            }
        }
    }
}

