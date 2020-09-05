//
//  ToiletDataTableViewController1.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/25/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SegementSlide
import SideMenu
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class ToiletDataTableViewController: UITableViewController,SegementSlideContentScrollViewDelegate {

     let fetchData = FetchDogData()
     var toiletDataInfoArray = [ToiletInfo]()
     var deleteArert = deleteAlert()
     var dogId:String?

     override func viewDidLoad() {
         super.viewDidLoad()
         fetchToiletData()
         
         // サイドバーメニューからの通知を受け取る
        NotificationCenter.default.addObserver(
         self,selector: #selector(catchSelectMenuNotification(notification:)),name:Notification.Name("dataDogID"),object: nil)
        
        //Documentの削除アクションを受け取る
        NotificationCenter.default.addObserver(
            self,selector:
            #selector(catchDeleteEndNotification(notification:)),name:Notification
            .Name("deleteDocument"),object: nil)
        
        //カスタムセルを定義
         let nib = UINib(nibName: "DataLogTableViewCell", bundle: nil)
        //register()の引数に渡す定数「nib」を定義
         tableView.register(nib, forCellReuseIdentifier: "dataLogCell")
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
       if self.toiletDataInfoArray.count == 0 {
         return 1
       }else{
         return toiletDataInfoArray.count
//        return 372 // 12/1Day × 31Days(1Month)
        }
       
   }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let toiletDataCell = tableView.dequeueReusableCell(withIdentifier: "dataLogCell", for: indexPath) as! DataLogTableViewCell
        
         let toietDayLabel = toiletDataCell.viewWithTag(1) as! UILabel
         let toiletPlaceLabel = toiletDataCell.viewWithTag(2) as! UILabel
         let toiletTypeLabel = toiletDataCell.viewWithTag(3) as! UILabel
       
       if self.toiletDataInfoArray.count == 0 {
           toiletDataCell.textLabel?.text = "データなし"
           toietDayLabel.text = ""
           toiletPlaceLabel.text = ""
           toiletTypeLabel.text = ""
        
         return toiletDataCell
       }else{
          //いつ食べたか時刻を表示
           toietDayLabel.text = self.toiletDataInfoArray[indexPath.row].toiletTimeString
           toiletPlaceLabel.text = self.toiletDataInfoArray[indexPath.row].toiletPlaceString
           toiletTypeLabel.text = self.toiletDataInfoArray[indexPath.row].toiletTypeString
        
           toiletDataCell.textLabel?.text = ""
        
           return toiletDataCell
       }
   }
    
    //セルがタップされたときの処理を行う
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.toiletDataInfoArray.count != 0 {
           let Id = self.toiletDataInfoArray[indexPath.row].toiletDocumentId
           let dId = self.dogId!
           print(Id as Any,"これがドキュメントID")
           print(Id as Any,"読み込み完了")
           UserDefaults.standard.set("toiletInfomation", forKey: "collectionId")
           UserDefaults.standard.set(Id, forKey: "deleteDocumentId")
           UserDefaults.standard.set(dId, forKey: "deleteNecessaryDogId")
            //Alertを出す
           present(deleteArert as! UIViewController, animated: true)
           }else if self.toiletDataInfoArray.count == 0 {
           print("エラーです")
           }
           self.tableView.deselectRow(at: indexPath, animated: true)
       }

     
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return view.frame.size.height/10
        }
    
    @objc var scrollView: UIScrollView{
         return tableView
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         print("ToiletのviewWillAppear呼ばれた")
         fetchToiletData()

     }
     
     
     func fetchToiletData(){
         self.toiletDataInfoArray.removeAll()
                 guard self.dogId != nil else {
                     //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
                     fetchData.fetchFirstDogId()
                     self.dogId = UserDefaults.standard.object(forKey: "dogFirstId") as! String
                 return }
         self.loadToiletInfo()
     }
         
         
         
         
     func loadToiletInfo() {
             print("Load呼ばれてる！")
        let fetchWaterInfo = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(self.dogId!).collection("toiletInfomation").order(by: "toiletTimeString", descending: true).limit(to: 50)
             fetchWaterInfo.getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                  print("snapShot手間")
                  //[]でtoiletInfoArrayを0にしておかないとセルが増えていくため、初期化する
                  self.toiletDataInfoArray.removeAll()
                  self.toiletDataInfoArray = []
                  print("snapShot後")
                    for document in querySnapshot!.documents {
                    if let toiletData = document.data() as? [String: Any] {
                         let documentId = document.documentID

                         let toiletTimeString = toiletData["toiletTimeString"] as? String

                         let toiletPlaceString = toiletData["toitelPlaceString"] as? String
                        
                         let toiletTypeString = toiletData["toiletTypeString"] as? String

                        self.toiletDataInfoArray.append(ToiletInfo(toiletTimeString: toiletTimeString!, toiletPlaceString: toiletPlaceString!, toiletDocumentId: documentId, toiletTypeString: toiletTypeString!))
                                }
                            }
                   //読み込みが終わったタイミングですぐにTableViewにリロードして反映
                   self.tableView.reloadData()
                   print("ToiletTableViewをリロード")
                   print("ToiletDataInfoの数",self.toiletDataInfoArray.count)
             }
         }
     }
     
     
      // 選択されたサイドバーのDogIDを取得
            @objc func catchSelectMenuNotification(notification: Notification) -> Void {
                // メニューからの返り値を取得
             self.dogId = notification.userInfo!["dataDogId"] as! String // 返り値が格納されている変数
             print(self.dogId! as Any, "ToiletでDogID変更取得できました")
             
             //犬を切り替えたらロードし直す
             loadToiletInfo()
         }
    
    @objc func catchDeleteEndNotification(notification: Notification) -> Void {
      //項目の削除が終わったら、リロードして即時にCell数を反映する
      self.loadToiletInfo()
      }
 }

