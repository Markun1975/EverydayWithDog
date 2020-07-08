//
//  resetPasswordViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 7/8/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class resetPasswordViewController: UIViewController {
    
    
    @IBOutlet var mailAddress: CustomUITextField!
    @IBOutlet var sendResetButton: UIButton!
    @IBOutlet var baseView: UIView!
    
    var emailString1:String?
       

    override func viewDidLoad() {
        super.viewDidLoad()
        emailString1 = UserDefaults.standard.object(forKey: "emailString") as! String
        
        mailAddress.text = emailString1
        
        //各Viewの設定
        mailAddressSetup()
        setupSenMailButton()
        baseViewSetup()
    }
    
    @IBAction func sendResetPassButton(_ sender: Any) {
           resetArert()
       }
     
  func resetArert() {
        let resetArert = UIAlertController(title: "再設定メールの送信", message: "再設定メールを送りますか？", preferredStyle: UIAlertController.Style.alert)
        
    
    
        let sendMailAction = UIAlertAction(title: "再設定", style: UIAlertAction.Style.default)
        { _ in
            //メールを送る
            Auth.auth().sendPasswordReset(withEmail: self.emailString1!) { error in
                            print("sendMail error")          
            }
            resetArert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default)
        { _ in
            print("キャンセル")
    }
        resetArert.addAction(cancelAction)
        resetArert.addAction(sendMailAction)
        present(resetArert, animated: true, completion: nil)
    }
    
    private func mailAddressSetup(){
           mailAddress.layer.cornerRadius = 10
           mailAddress.layer.borderColor = UIColor.black.cgColor
           mailAddress.layer.shadowColor = UIColor.black.cgColor
           mailAddress.layer.shadowOffset = CGSize(width: 0, height: 1)
           mailAddress.layer.shadowOpacity = 0.2
           mailAddress.layer.shadowRadius = 1
    }
    private func setupSenMailButton() {
        sendResetButton.layer.cornerRadius = 23
        sendResetButton.layer.shadowColor = UIColor.black.cgColor
        sendResetButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        sendResetButton.layer.shadowOpacity = 0.2
        sendResetButton.layer.shadowRadius = 1
    }
    
    private func baseViewSetup(){
               baseView.layer.cornerRadius = self.view.bounds.width/20
               baseView.layer.shadowColor = UIColor.gray.cgColor
               baseView.layer.shadowOffset = CGSize(width: 0, height: 1)
               baseView.layer.shadowOpacity = 0.1
               baseView.layer.shadowRadius = 0.1
    }
}
    
    



