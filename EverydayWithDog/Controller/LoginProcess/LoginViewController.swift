//
//  LoginViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Lottie

class LoginViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var newLogin: UIButton!
    
    @IBOutlet var loginView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newLogin.layer.cornerRadius = 27
        loginView.layer.cornerRadius = 27
        setUpAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func newLoginAction(_ sender: Any) {
        self.performSegue(withIdentifier: "newLogin", sender: nil)
    }
    
    
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    
    //アニメーション設定
    func setUpAnimation(){
         let animationView = AnimationView()
         let animation = Animation.named("dogAnimation")
         animationView.frame = CGRect(x: 23, y: 338, width: 329, height: 207)
         animationView.animation = animation
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .loop
         animationView.play()
        self.view.addSubview(animationView)
    }
    
}
        
