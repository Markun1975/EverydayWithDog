//
//  FriendProfileViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/26/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SDWebImage

class FriendProfileViewController: UIViewController {

 @IBOutlet var friendView: UIView!
 
 var profileImageData = UIImage()
 var profile:String! //プロフィール写真
 var name:String! //名前
 var sex:String! //性別
 var dogType:String! //犬種
 var memo:String!//メモ
 var input:String! //入力日時
 
 @IBOutlet var profileIconImage: UIImageView!
 
 @IBOutlet var nameLabel: UILabel!
 
 @IBOutlet var sexLabel: UILabel!
 
 @IBOutlet var typeLabel: UILabel!
    
 @IBOutlet var memoLabel: UILabel!
    
 
 
override func viewDidLoad() {
        super.viewDidLoad()
        
        profileIconImage.layer.cornerRadius = profileIconImage.frame.size.width * 0.5
        profileIconImage.clipsToBounds = true
    }
        
    override func viewWillAppear(_ animated: Bool) {
        profile = UserDefaults.standard.object(forKey: "friendDogProfileImage") as! String
        
        name = UserDefaults.standard.object(forKey: "friendDogName") as! String
        
        sex = UserDefaults.standard.object(forKey: "friendDogSex") as! String
        
        dogType = UserDefaults.standard.object(forKey: "friendDogType") as! String
        
        memo = UserDefaults.standard.object(forKey: "friendDogMemo") as! String
        
//        profileIconImage.sd_setImage(with: URL(string: UserDefaults.standard.object(forKey: "imageString") as! String), completed: nil)
        
        profileIconImage!.sd_setImage(with: URL(string: profile!), completed: nil)
        nameLabel!.text = name!
        sexLabel!.text = sex!
        typeLabel!.text = dogType!
        memoLabel!.text = memo!
    }
}

