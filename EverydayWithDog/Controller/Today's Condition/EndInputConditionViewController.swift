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
            animationView.frame = CGRect(x: 45, y: 320, width: 285, height: 172)
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            animationView.play()
           self.view.addSubview(animationView)
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
    }
}
