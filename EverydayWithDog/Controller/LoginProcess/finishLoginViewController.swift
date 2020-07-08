//
//  finishLoginViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/28/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Lottie

class finishLoginViewController: UIViewController {
    
    @IBOutlet var nemuButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCheckAnimation()
        setupMainButton()
    }
    
    @IBAction func TopMenu(_ sender: Any) {
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! UITabBarController
        self.show(tabBarController, sender: nil)
        
        }
    
    //ログイン完了のアニメーション
    func setUpCheckAnimation(){
         let animationView = AnimationView()
         let animation = Animation.named("check")
        animationView.frame = CGRect(x: self.view.frame.size.width/3, y: self.view.frame.size.width/3, width: self.view.frame.size.width/4, height: self.view.frame.size.width/3)
        animationView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
         animationView.animation = animation
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .playOnce
         animationView.play()
        self.view.addSubview(animationView)
    }
    
    func setupMainButton() {
        nemuButton.layer.cornerRadius = 23
        nemuButton.layer.shadowColor = UIColor.black.cgColor
        nemuButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        nemuButton.layer.shadowOpacity = 0.2
        nemuButton.layer.shadowRadius = 1
    }
        
    }
    
