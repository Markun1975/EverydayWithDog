//
//  FriendProfileViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/26/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class FriendProfileViewController: UIViewController {
    @IBOutlet var TopFriendProfileView: UIView!
    
 var profileImageData = UIImage()
 var profile:String! //プロフィール写真
 var name:String! //名前
 var sex:String! //性別
 var dogType:String! //犬種
 var memo:String!//メモ
 var input:String! //入力日時
 
 @IBOutlet var profileIconImage: UIImageView!
 
 @IBOutlet var nameLabel: UILabel!
 
 @IBOutlet var sexIcon: UIImageView!
    
 
 @IBOutlet var typeLabel: UILabel!
    
 @IBOutlet var memoLabel: UILabel!
    
    @IBOutlet var Label1: UILabel!
    
 
override func viewDidLoad() {
        super.viewDidLoad()
    
    //ImageView設定
    profileIconImage.layer.cornerRadius = profileIconImage.frame.size.width/2
    profileIconImage.clipsToBounds = true
    profileIconImage.layer.borderColor = UIColor.white.cgColor
    profileIconImage.layer.borderWidth = 4
    
    labelSetup(setLabel: Label1)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        profile = UserDefaults.standard.object(forKey: "friendDogProfileImage") as! String
        
        name = UserDefaults.standard.object(forKey: "friendDogName") as! String
        
        sex = UserDefaults.standard.object(forKey: "friendDogSex") as! String
        
        dogType = UserDefaults.standard.object(forKey: "friendDogType") as! String
        
        memo = UserDefaults.standard.object(forKey: "friendDogMemo") as! String
        
//        profileIconImage.sd_setImage(with: URL(string: UserDefaults.standard.object(forKey: "imageString") as! String), completed: nil)
        
        profileIconImage!.sd_setImage(with: URL(string: profile!), completed: nil)
        if sex == "男の子" {
            sexIcon.image = UIImage(named: "male")
            sexIcon.tintColor = UIColor.blue
        } else if sex == "女の子"{
            sexIcon.image = UIImage(named: "female")
            sexIcon.tintColor = UIColor.red
        } else {
            sexIcon.image = UIImage(named: "male")
            sexIcon.tintColor = UIColor.red
        }
        nameLabel!.text = name!
        typeLabel!.text = dogType!
        memoLabel!.text = memo!
    }
    
    
    @IBAction func friendDogDeleteMethod(_ sender: Any) {
        //AlertInstance
        let friendDogDeleteAlert: UIAlertController =
            UIAlertController(title: "削除してよろしいですか？", message: "友達の情報を削除します", preferredStyle: UIAlertController.Style.alert)
        
        //AlertAction
        let dogDeleteAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            let documentID = UserDefaults.standard.object(forKey: "friendDogId")
            
            let dogID = UserDefaults.standard.object(forKey: "deleteNecessaryDogId")
                //FriendDocument情報を削除
                let db =  Firestore.firestore().collection("user").document(uid!).collection("friendList").document(documentID as! String)
                db.delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("delete Success")
                }
            }
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("deleteFriendDocument"), object: nil)
        })
        //CancelAction
        let dogDeleteCancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
              // ボタンが押された時の処理を書く（クロージャ実装）
              (action: UIAlertAction!) -> Void in
            friendDogDeleteAlert.dismiss(animated: true, completion: nil)
          })
        
        friendDogDeleteAlert.addAction(dogDeleteAction)
        friendDogDeleteAlert.addAction(dogDeleteCancelAction)
        
        present(friendDogDeleteAlert, animated: true, completion: nil)
    }
    
    

    @IBAction func closeProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        iconCornerRadius()
    }
    
    private func iconCornerRadius(){
        //Icon
        profileIconImage.layer.cornerRadius = profileIconImage.frame.height/2
        profileIconImage.clipsToBounds = true
    }
    
    func labelSetup(setLabel: UILabel){
        var label = UILabel()
        label = setLabel
        label.layer.borderWidth = 0.25  // 枠線の幅
        label.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}

