//
//  SettingViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 4/21/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingViewController: UIViewController {
    
    @IBOutlet var userIdLabel: UILabel!
    
    @IBOutlet var myDogNumber: UILabel!
    
    @IBOutlet var friendDogsNumber: UILabel!
    
    @IBOutlet var LogOutButton: UIButton!
    
    
    @IBOutlet var exit: UIButton!
    
    @IBOutlet var centerLabel: UILabel!
    
    
    @IBOutlet var baseTopView: UIView!
    
    
    @IBOutlet var baseCenterView: UIView!
    
    var userEmail:String?
    
    var myDogCounts:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView(baseView: baseTopView)
        baseView(baseView: baseCenterView)

        //navigationbar 下部のY座標が変わってしまうのを防ぐために設定
        self.navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
        
        centerLabel.layer.borderWidth = 1
        centerLabel.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.26).cgColor
        
        let user = Auth.auth().currentUser
        
        if user == nil {
            print("nowUser取得エラー")
        } else {
            self.userEmail = user?.email
            self.userIdLabel.text = self.userEmail
        }
        
        self.myDogNumber.text = UserDefaults.standard.object(forKey: "dogcounts") as? String
        self.friendDogsNumber.text = UserDefaults.standard.object(forKey: "friendDogcounts") as? String
        
        LogOutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        exit.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func logOutProgress(_ sender: Any) {
        do {
            try Auth.auth().signOut()
           } catch let error {
               print(error)
           }
        let topStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let topVC = topStoryboard.instantiateViewController(identifier: "LoginView")
        self.show(topVC, sender: self)
    }
    
    func baseView(baseView: UIView){
        var baseview = UIView()
        baseview = baseView
        
        baseView.layer.cornerRadius = self.view.bounds.width/20
        baseView.layer.shadowColor = UIColor.gray.cgColor
        baseView.layer.shadowOffset = CGSize(width: 0, height: 1)
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowRadius = 0.1
    }
}
