//
//  deleteAlert.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/17/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class deleteAlert: UIAlertController{


    override func viewWillAppear(_ animated: Bool) {
        deleteAlertAction()
    }
    
     func deleteAlertAction(){
        let dataAlert = UIAlertController(title: "削除しますか？", message: "この履歴を削除しますか？", preferredStyle: UIAlertController.Style.alert)
        
            let deleteCanceAction = UIAlertAction(title: "キャンセル", style: .default) { _ in
                dataAlert.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                print("キャンセル")
                }
        
        let deleteAction = UIAlertAction(title: "削除", style: .destructive)
            { _ in
                //TableViewから送られてきたDataViewとDogIDと削除するDocumentIDを定義
                let dataTableView = UserDefaults.standard.object(forKey: "collectionId")
                print(dataTableView!)
                let documentID = UserDefaults.standard.object(forKey: "deleteDocumentId")
                                print(documentID!,"が削除できた!")
                let dogID = UserDefaults.standard.object(forKey: "deleteNecessaryDogId")
                //Document情報を削除
                let db =  Firestore.firestore().collection("user").document(uid!).collection("dogList").document(dogID as! String).collection(dataTableView! as! String).document(documentID as! String)
                db.delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("delete Error")
                }
            }
                //削除が終わったらAlertを消し、NotificationCenterでリロード処理をする
                dataAlert.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name("deleteDocument"), object: nil)
        }
                dataAlert.addAction(deleteCanceAction)
                dataAlert.addAction(deleteAction)
                present(dataAlert, animated: true)
    }
}
