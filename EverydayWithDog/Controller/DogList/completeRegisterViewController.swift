//
//  completeRegisterViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit

class completeRegisterViewController: UIViewController {
    
    @IBOutlet var backTop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        backTop.layer.shadowColor = UIColor.black.cgColor
        backTop.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        backTop.layer.shadowOpacity = 0.5
        
        let backButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        
        navigationItem.backBarButtonItem = backButtonItem
    }
    
    @IBAction func backToTop(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
}

