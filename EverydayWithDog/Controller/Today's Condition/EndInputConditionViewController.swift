//
//  EndInputConditionViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/13/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Lottie

class EndInputConditionViewController: UIViewController {
    
    var timer:Timer!
    
    @IBOutlet var popUp: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        setUpMemoAnimation()
        //二秒後にTop画面へ繊維
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(backConditionView), userInfo: nil, repeats: false)
    }
    
    //登録完了のアニメーションの設定
    func setUpMemoAnimation(){
        
            let animationView = AnimationView()
            let animation = Animation.named("memoAnimation")
        self.popUp.addSubview(animationView)
        //Animationが中央に来ないためX軸で調整
        animationView.frame = CGRect(x: popUp.frame.width/4, y: 0, width: popUp.frame.width/2, height: popUp.frame.height - popUp.frame.height/4)
        animationView.centerYAnchor.constraint(equalTo: self.popUp.centerYAnchor).isActive = true
            animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .playOnce
            animationView.play()
           
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // タイマーを停止する
        if let workingTimer = timer{
            workingTimer.invalidate()
        }
    }
    
    @objc func backConditionView(){
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
