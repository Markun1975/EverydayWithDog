//
//  EndInputScheduleViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/13/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Lottie

class EndInputScheduleViewController: UIViewController {
    
    @IBOutlet var backToCalendar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        backToCalendar.layer.cornerRadius = 6
        setUpCalendarAnimation()
    }
    
    func setUpCalendarAnimation(){
         let animationView = AnimationView()
         let animation = Animation.named("calendarAnimation")
         animationView.frame = CGRect(x: 45, y: 320, width: 285, height: 172)
         animationView.animation = animation
         animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
         animationView.play()
        self.view.addSubview(animationView)
    }
    
    @IBAction func selfnavigationControllerpopToRootViewControlleranimatedtruebackToCalendar(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
}
