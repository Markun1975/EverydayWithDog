//
//  ProfileViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 2/2/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
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
    
    @IBOutlet var sexLabel: UILabel!
    
    @IBOutlet var typeLabel: UILabel!
    
    @IBOutlet var birthLabel: UILabel!
    
    @IBOutlet var chipIdLabel: UILabel!
    
    @IBOutlet var contraceptionLabel: UILabel!
    
    @IBOutlet var personalityLabel: UILabel!
    
    @IBOutlet var rabiesLabel: UILabel!
    
    @IBOutlet var filariaLabel: UILabel!
    
    @IBOutlet var memoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileIconImage.layer.cornerRadius = profileIconImage.frame.size.width * 0.5
        profileIconImage.clipsToBounds = true
    }
        
    override func viewWillAppear(_ animated: Bool) {
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
        
//        profileIconImage.sd_setImage(with: URL(string: UserDefaults.standard.object(forKey: "imageString") as! String), completed: nil)
        profileIconImage!.sd_setImage(with: URL(string: profile!), completed: nil)
        nameLabel!.text = name!
        sexLabel!.text = sex!
        typeLabel!.text = dogType!
        birthLabel!.text = birth!
        chipIdLabel!.text = chipId!
        contraceptionLabel!.text = contraception!
        personalityLabel!.text = personality!
        rabiesLabel!.text = rabies!
        filariaLabel!.text = filaria!
        memoLabel!.text = memo!
    }
}
