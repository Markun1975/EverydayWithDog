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
    }
    
    @IBAction func TopMenu(_ sender: Any) {
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! UITabBarController
        self.show(tabBarController, sender: nil)
        }
    
    //ログイン完了のアニメーション
    func setUpCheckAnimation(){
         let animationView = AnimationView()
         let animation = Animation.named("check")
         animationView.frame = CGRect(x: 45, y: 320, width: 285, height: 172)
         animationView.animation = animation
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .playOnce
         animationView.play()
        self.view.addSubview(animationView)
    }
        
    }
    
