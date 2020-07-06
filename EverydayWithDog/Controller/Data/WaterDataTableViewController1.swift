//
//  WaterDataTableViewController1.swift
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

class WaterDataTableViewController1: UITableViewController,SegementSlideContentScrollViewDelegate {

      let fetchData = FetchDogData()
      var waterDataInfoArray = [WaterInfo]()
      var deleteArert = deleteAlert()
      var dogId:String?

      override func viewDidLoad() {
          super.viewDidLoad()
          fetchWaterData()
          
        // サイドバーメニューからの通知を受け取る
        NotificationCenter.default.addObserver(
          self,selector: #selector(catchSelectMenuNotification(notification:)),name:Notification.Name("dataDogID"),object: nil)
        
        //Documentの削除アクションを受け取る
        NotificationCenter.default.addObserver(
        self,selector:
        #selector(catchDeleteEndNotification(notification:)),name:Notification
        .Name("deleteDocument"),object: nil)
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
        if self.waterDataInfoArray.count == 0 {
          return 1
        }else{
          return waterDataInfoArray.count
        }
        
    }

      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if self.waterDataInfoArray.count == 0 {
            cell.textLabel?.text = "データなし"
          return cell
        }else{
          //いつ食べたか時刻を表示
          cell.textLabel?.text = self.waterDataInfoArray[indexPath.row].waterTimeString
          cell.detailTextLabel?.text = self.waterDataInfoArray[indexPath.row].waterPlaceString
            return cell
        }
    }
    
    //セルがタップされたときの処理を行う
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.waterDataInfoArray.count != 0 {
        let Id = self.waterDataInfoArray[indexPath.row].waterDocumentId
        let dId = self.dogId!
        print(Id as Any,"これがドキュメントID")
        print(Id as Any,"読み込み完了")
        UserDefaults.standard.set("waterInfomation", forKey: "collectionId")
        UserDefaults.standard.set(Id, forKey: "deleteDocumentId")
        UserDefaults.standard.set(dId, forKey: "deleteNecessaryDogId")
        //Alertを出す
        present(deleteArert as! UIViewController, animated: true)
        }else if self.waterDataInfoArray.count == 0{
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
          print("WaterのviewWillAppear呼ばれた")
          fetchWaterData()
      }
      
      
      func fetchWaterData(){
          self.waterDataInfoArray.removeAll()
                  guard self.dogId != nil else {
                      //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
                      fetchData.fetchFirstDogId()
                      self.dogId = UserDefaults.standard.object(forKey: "dogFirstId") as! String
                  return }
          self.loadWaterInfo()
      }
          
          
          
          
      func loadWaterInfo() {
              let fetchWaterInfo = Firestore.firestore().collection("user").document(uid!).collection("dogList").document(self.dogId!).collection("waterInfomation").limit(to: 50)
              fetchWaterInfo.getDocuments() { (querySnapshot, err) in
                  if let err = err {
                      print("Error getting documents: \(err)")
                  } else {
                   //[]でwaterInfoArrayを0にしておかないとセルが増えていくため、初期化する
                   self.waterDataInfoArray.removeAll()
                   self.waterDataInfoArray = []
                      for document in querySnapshot!.documents {
                          if let waterData = document.data() as? [String: Any] {
                               let documentId = document.documentID
                            
                               let waterString = waterData["waterString"] as? String

                               let waterTimeString = waterData["drinkTimeString"] as? String

                               let waterPlaceString = waterData["drinkPlaceString"] as? String

                            self.waterDataInfoArray.append(WaterInfo(waterString: waterString!, waterTimeString: waterTimeString!, waterPlaceString: waterPlaceString!, waterDocumentId: documentId))
                                 }
                             }
                    //読み込みが終わったタイミングですぐにTableViewにリロードして反映
                    self.tableView.reloadData()
                    print("WaterTableViewをリロード")
                    print("WaterDataInfoの数",self.waterDataInfoArray.count)
              }
          }
      }
      
      
       // 選択されたサイドバーのDogIDを取得
             @objc func catchSelectMenuNotification(notification: Notification) -> Void {
                 // メニューからの返り値を取得
              self.dogId = notification.userInfo!["dataDogId"] as! String // 返り値が格納されている変数
              print(self.dogId! as Any, "WaterでDogID変更取得できました")
              
            //犬を切り替えたらロードし直す
            loadWaterInfo()
          }
    
    @objc func catchDeleteEndNotification(notification: Notification) -> Void {
    //項目の削除が終わったら、リロードして即時にCell数を反映する
    self.loadWaterInfo()
    }
          
      
      
      
  }

