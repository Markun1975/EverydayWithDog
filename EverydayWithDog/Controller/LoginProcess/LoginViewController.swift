//  LoginViewController.swift
//  EverydayWithDog
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.

import UIKit
import Firebase
//import FirebaseUI

class LoginViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var newLogin: UIButton!
    
    @IBOutlet var loginView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newLogin.layer.cornerRadius = 23
        loginView.layer.cornerRadius = 23
        
        newLogin.layer.shadowColor = UIColor.black.cgColor
        newLogin.layer.shadowOffset = CGSize(width: 0, height: 1)
        newLogin.layer.shadowOpacity = 0.2
        newLogin.layer.shadowRadius = 1
        
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.layer.shadowOffset = CGSize(width: 0, height: 1)
        loginView.layer.shadowOpacity = 0.1
        loginView.layer.shadowRadius = 1
        
        view.addSubview(newLogin)
        view.addSubview(loginView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
        //ログイン常態か判別
        guard let uid = Auth.auth().currentUser?.uid else {
        return print("no current user!ログインし直してください！")
        }
        continueUserAction()
    }
    
    private func continueUserAction() {
        let MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! UITabBarController
        self.show(MainViewController, sender: nil)
    }
    
    @IBAction func newLoginAction(_ sender: Any) {
        self.performSegue(withIdentifier: "newLogin", sender: nil)
    }
    
    
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: "login", sender: nil)
    }
}
        
