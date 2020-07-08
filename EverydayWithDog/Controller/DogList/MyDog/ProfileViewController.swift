//
//  ProfileViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 2/2/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore


class ProfileViewController: UIViewController {
    
    @IBOutlet var TopProfileView: UIView!
    
    var profileImageData = UIImage()
    var profile:String! //プロフィール写真
    var name:String! //名前"
    var sex:String! //性別
    var dogType:String! //犬種
    var birth:String!//お誕生日
    var chipId:String!//ICチップ番号
    var contraception:String!  //避妊有無
    var personality:String!//性格
    var rabies:String! //狂犬病予防接種有無
    var filaria:String! //フェラリア予防ゆ有無
    var memo:String!//メモ
    var input:String! //入力日時
    
    @IBOutlet var profileIconImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var sexIcon: UIImageView!
    
    @IBOutlet var typeLabel: UILabel!
    
    @IBOutlet var birthLabel: UILabel!
    
    @IBOutlet var chipIdLabel: UILabel!
    
    @IBOutlet var contraceptionLabel: UILabel!
    
    @IBOutlet var personalityLabel: UILabel!
    
    @IBOutlet var rabiesLabel: UILabel!
    
    @IBOutlet var filariaLabel: UILabel!
    
    @IBOutlet var memoLabel: UILabel!
    
    @IBOutlet var Label1: UILabel!
    
    @IBOutlet var Label2: UILabel!
    
    @IBOutlet var Label3: UILabel!
    
    @IBOutlet var Label4: UILabel!
    
    @IBOutlet var Label5: UILabel!
    
    @IBOutlet var Label6: UILabel!
    
    @IBOutlet var Label7: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ImageView設定
        profileIconImage.layer.cornerRadius = profileIconImage.frame.size.width/2
        profileIconImage.clipsToBounds = true
        profileIconImage.layer.borderColor = UIColor.white.cgColor
        profileIconImage.layer.borderWidth = 4
        
        allLabelSetup()
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        setMyDogData()
    }
    
    
    
    
    func setMyDogData(){
        //各Labelへ犬の情報を表示させる
        profile = UserDefaults.standard.object(forKey: "imageString") as! String
        name = UserDefaults.standard.object(forKey: "name") as! String
        sex = UserDefaults.standard.object(forKey: "sex") as! String
        dogType = UserDefaults.standard.object(forKey: "type") as! String
        birth = UserDefaults.standard.object(forKey: "birth") as! String
        chipId = UserDefaults.standard.object(forKey: "chipId") as! String
        contraception = UserDefaults.standard.object(forKey: "contraception") as! String
        personality = UserDefaults.standard.object(forKey: "personality") as! String
        rabies = UserDefaults.standard.object(forKey: "rabies") as! String
        filaria = UserDefaults.standard.object(forKey: "filaria") as! String
        memo = UserDefaults.standard.object(forKey: "memo") as! String
        
        
        profileIconImage!.sd_setImage(with: URL(string: profile!), completed: nil)
        nameLabel!.text = name!
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
        typeLabel!.text = dogType!
        birthLabel!.text = birth!
        chipIdLabel!.text = chipId!
        contraceptionLabel!.text = contraception!
        personalityLabel!.text = personality!
        rabiesLabel!.text = rabies!
        filariaLabel!.text = filaria!
        memoLabel!.text = memo!
    }
    
    @IBAction func dogDeleteMethod(_ sender: Any) {
        let myDogId = UserDefaults.standard.object(forKey: "myDogId")
        
        //AlertInstance
        let dogDeleteAlert: UIAlertController =
            UIAlertController(title: "削除してよろしいですか？", message: "ワンちゃんの情報を削除します", preferredStyle: UIAlertController.Style.alert)
        
        //AlertAction
        let dogDeleteAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            //FriendDocument情報を削除
            let db =  Firestore.firestore().collection("user").document(uid!).collection("dogList").document(myDogId as! String)
                db.delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("delete Success")
                }
            }
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("deleteMyDogDocument"), object: nil)
            print("愛犬の情報削除OK")
        })
        //CancelAction
        let dogDeleteCancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
              // ボタンが押された時の処理を書く（クロージャ実装）
              (action: UIAlertAction!) -> Void in
            dogDeleteAlert.dismiss(animated: true, completion: nil)
              print("Cancel")
          })
        
        dogDeleteAlert.addAction(dogDeleteAction)
        dogDeleteAlert.addAction(dogDeleteCancelAction)
        
        present(dogDeleteAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func allLabelSetup(){
        labelSetup(setLabel: Label1)
        labelSetup(setLabel: Label2)
        labelSetup(setLabel: Label3)
        labelSetup(setLabel: Label4)
        labelSetup(setLabel: Label5)
        labelSetup(setLabel: Label6)
        labelSetup(setLabel: Label7)
    }
    
    func labelSetup(setLabel: UILabel){
        var label = UILabel()
        label = setLabel
        label.layer.borderWidth = 0.25  // 枠線の幅
        label.layer.borderColor = UIColor.lightGray.cgColor
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
}
