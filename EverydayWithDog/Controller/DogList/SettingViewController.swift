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
    
    var userEmail:String?
    
    var myDogCounts:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        if user == nil {
            print("nowUser取得エラー")
        } else {
            self.userEmail = user?.email
            self.userIdLabel.text = self.userEmail
        }
        
//        self.myDogCounts = UserDefaults.standard.object(forKey: "dogcounts") as? String
        UserDefaults.standard.object(forKey: "")
        self.myDogNumber.text = UserDefaults.standard.object(forKey: "dogcounts") as? String
        self.friendDogsNumber.text = UserDefaults.standard.object(forKey: "friendDogcounts") as? String
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
    
    
    

}
