//
//  WalkDataTableViewController1.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/25/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SegementSlide
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class WalkDataTableViewController1: UITableViewController,SegementSlideContentScrollViewDelegate {

       let fetchData = FetchDogData()
       var walkDataInfoArray = [WalkInfo]()
       var deleteArert = deleteAlert()
       var dogId:String?

       override func viewDidLoad() {
           super.viewDidLoad()
           fetchWalkData()
           
           // サイドバーメニューからの通知を受け取る
           NotificationCenter.default.addObserver(
           self,selector: #selector(catchSelectMenuNotification(notification:)),name:Notification.Name("dataDogID"),object: nil)
        
        //Documentの削除アクションを受け取る
           NotificationCenter.default.addObserver(
               self,selector:
               #selector(catchDeleteEndNotification(notification:)),name:Notification
               .Name("deleteDocument"),object: nil)
        
        //カスタムセルを定義
         let nib = UINib(nibName: "WalkDataViewCellTableViewCell", bundle: nil)
        //register()の引数に渡す定数「nib」を定義
         tableView.register(nib, forCellReuseIdentifier: "walkDayDataCell")
       }

       // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0)
        headerView.backgroundColor = .white
        headerView.layer.shadowColor = UIColor.gray.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowOpacity = 0.5
       self.view.addSubview(headerView)
        return headerView
    }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if self.walkDataInfoArray.count == 0 {
           return 1
         }else{
           return walkDataInfoArray.count
         }
         
     }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let walkDataCell = tableView.dequeueReusableCell(withIdentifier: "walkDayDataCell", for: indexPath) as! WalkDataViewCellTableViewCell
        
         let walkDayLabel = walkDataCell.viewWithTag(1) as! UILabel
         let walkTimeLabel = walkDataCell.viewWithTag(2) as! UILabel
         let walkDistanceLabel = walkDataCell.viewWithTag(3) as! UILabel
        
         if self.walkDataInfoArray.count == 0 {
            //データが無い場合は中央のラベルは表示し他の３項目は非表示
             walkDataCell.textLabel?.text = "データなし"
             walkDayLabel.text = ""
             walkTimeLabel.text = ""
             walkDistanceLabel.text = ""
             
           return walkDataCell
         }else{
                   
           //運動した日時
           walkDayLabel.text = walkDataInfoArray[indexPath.row].dayString
           //運動した時間
           walkTimeLabel.text = walkDataInfoArray[indexPath.row].walkTimeString
           //運動した距離
           walkDistanceLabel.text = walkDataInfoArray[indexPath.row].distanceString
            
           //データが有る場合は中央のラベルは非表示
           walkDataCell.textLabel?.text = ""
                  
           return walkDataCell
         }
     }
    
    

    //セルがタップされたときの処理を行う
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if self.walkDataInfoArray.count != 0 {
           let Id = self.walkDataInfoArray[indexPath.row].walkDocumentId
           let dId = self.dogId!
           print(Id as Any,"これがドキュメントID")
           print(Id as Any,"読み込み完了")
           UserDefaults.standard.set("walkInfomation", forKey: "collectionId")
           UserDefaults.standard.set(Id, forKey: "deleteDocumentId")
           UserDefaults.standard.set(dId, forKey: "deleteNecessaryDogId")
               //Alertを出す
              present(deleteArert as! UIViewController, animated: true)
           }else if self.walkDataInfoArray.count == 0{
               print("エラーです")
           }
           self.tableView.deselectRow(at: indexPath, animated: true)
       }
    
       
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return view.frame.size.height/9
          }
    
    @objc var scrollView: UIScrollView{
         return tableView
     }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           print("WalkのviewWillAppear呼ばれた")
           fetchWalkData()
  
       }
       
       
       func fetchWalkData(){
           self.walkDataInfoArray.removeAll()
                   guard self.dogId != nil else {
                       //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
                       fetchData.fetchFirstDogId()
                       self.dogId = UserDefaults.standard.object(forKey: "dogFirstId") as! String
                   return }
           self.loadWalkInfo()
       }
           
           
           
           
       func loadWalkInfo() {
               print("Load呼ばれてる！")
               let fetchWalkInfo = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(self.dogId!).collection("walkInfomation").limit(to: 50)
               fetchWalkInfo.getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                    print("snapShot手間")
                    //[]でwaterInfoArrayを0にしておかないとセルが増えていくため、初期化する
                    self.walkDataInfoArray.removeAll()
                    self.walkDataInfoArray = []
                    print("snapShot後")
                       for document in querySnapshot!.documents {
                          if let walkData = document.data() as? [String: Any] {
                                 let documentId = document.documentID
                            
                                 let startTimeString = walkData["startTimeString"] as? String
                                                     
                                 let walkTimeString = walkData["walkTime"] as? String

                                 let walkPlaceString = walkData["walkPlaceString"] as? String

                                 let walkDistanceStirng = walkData["walkDistanceStirng"] as? String
                                                     
                            self.walkDataInfoArray.append(WalkInfo(dayString: startTimeString!, walkTimeString: walkTimeString!, walkPlaceString: walkPlaceString!, distanceString: walkDistanceStirng! + "km", walkDocumentId: documentId))
                                  }
                              }
                     //読み込みが終わったタイミングですぐにTableViewにリロードして反映
                     self.tableView.reloadData()
                     print("WalkTableViewをリロード")
                     print("WalkDataInfoの数",self.walkDataInfoArray.count)
               }
           }
       }
       
       
        // 選択されたサイドバーのDogIDを取得
              @objc func catchSelectMenuNotification(notification: Notification) -> Void {
                  // メニューからの返り値を取得
               self.dogId = notification.userInfo!["dataDogId"] as! String // 返り値が格納されている変数
               print(self.dogId! as Any, "WaterでDogID変更取得できました")
               
               //犬を切り替えたらロードし直す
               loadWalkInfo()
           }
    
    @objc func catchDeleteEndNotification(notification: Notification) -> Void {
    //項目の削除が終わったら、リロードして即時にCell数を反映する
    self.loadWalkInfo()
    }
           
       
       
       
   }


