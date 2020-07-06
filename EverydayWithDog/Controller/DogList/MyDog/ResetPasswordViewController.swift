//
//  ResetPasswordViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 6/2/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore


class ResetPasswordViewController: UIViewController {
    
    @IBOutlet var mailAddress: UILabel!
    @IBOutlet var sendResetButton: UIButton!
    
    var emailString1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailString1 = UserDefaults.standard.object(forKey: "emailString") as! String
        emailString1 = mailAddress.text!

    }
    
    
    @IBAction func sendResetPassButton(_ sender: Any) {
        resetArert()
    }
    
    func resetArert() {
        let resetArert = UIAlertController(title: "再設定メールの送信", message: "ご登録のメールアドレスに再設定メールを送りますか？", preferredStyle: UIAlertController.Style.alert)
                
                let cancelAction = UIAlertAction(title: "キャンセル", style: .default)
                { _ in
                resetArert.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                print("キャンセル")
                }
                let sendMailAction = UIAlertAction(title: "メールを送る", style: .default)
                {_ in
        //            Auth.auth().sendPasswordReset(withEmail: self.emailString1) { error in
        //                print("sendMail error")
                    resetArert.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                resetArert.addAction(cancelAction)
                resetArert.addAction(sendMailAction)
        }
}

