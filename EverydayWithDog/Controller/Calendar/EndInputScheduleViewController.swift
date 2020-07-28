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
        animationView.frame = CGRect(x: view.frame.width/4, y: view.frame.height/3, width: view.frame.width/2, height: view.frame.height/3)
         animationView.animation = animation
         animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
         animationView.play()
        self.view.addSubview(animationView)
    }
    
    @IBAction func selfnavigationControllerpopToRootViewControlleranimatedtruebackToCalendar(_ sender: Any) {
//        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
