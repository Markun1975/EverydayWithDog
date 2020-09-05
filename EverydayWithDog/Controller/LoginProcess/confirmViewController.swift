//
//  confirmViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase

class confirmViewController: UIViewController {
    
    @IBOutlet var mailAddress: UITextField!
    
    @IBOutlet var passWord: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var forgotPasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //アドレス入力欄設定
        mailAddressSetup()
        //パスワード入力欄設定
        passwordSetup()
        //ログインボタン設定
        loginButtonSetup()
        view.addSubview(loginButton)
    }
    
    @IBAction func loginAction(_ sender: Any) {
       let email = mailAddress.text ?? ""
       let password = passWord.text ?? ""
       
       if email == "" || password == "" {
           displayAlertMessage(userMessage:"全て入力してください")
           return
       }else {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
                if let user = result?.user {
                    // サインイン後の画面へ
                    self.performSegue(withIdentifier: "goToTop", sender: nil)
                    print("ログイン成功")
                }else{
                self.showErrorIfNeeded(error)
                print("ログイン失敗")
            }
         }
       }
    }
    
    
    @IBAction func resetPasswordProcessing(_ sender: Any) {
        let mailText = mailAddress.text
        if mailText == nil || mailText == "" { displayAlertMessage(userMessage:"メールアドレスを入力してください")
        } else {
            resetPasswordAlertMessage()
        }
    }
    
    
    
    //ログイン時にエラー発生時、メッセージ
    func showError (_ errorOrNil: Error?) {
        //エラーながなければ作動しない
        guard let error = errorOrNil else { return }
        
        let message = errorMessage(of: error) // エラーメッセージを取得
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
    }
    
    
    //エラーの分岐をおこないます
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard let error = errorOrNil else { return }
         
        let message = errorMessage(of: error) // エラーメッセージを取得
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
     
    private func errorMessage(of error: Error) -> String {
        var message = "エラーが発生しました"
        guard let errcd = AuthErrorCode(rawValue: (error as NSError).code) else {
            return message
        }
         
        switch errcd {
        case .networkError: message = "ネットワークに接続できません"
        case .userNotFound: message = "ユーザが見つかりません"
        case .invalidEmail: message = "不正なメールアドレスです"
        case .emailAlreadyInUse: message = "このメールアドレスは既に使われています"
        case .wrongPassword: message = "入力した認証情報でサインインできません"
        case .userDisabled: message = "このアカウントは無効です"
        case .weakPassword: message = "パスワードが脆弱すぎます"
        default: break
        }
        return message
    }
        
        

    func displayAlertMessage(userMessage: String) {
            let alert = UIAlertController(title: "確認", message: userMessage, preferredStyle: UIAlertController.Style.alert)
            let okMessage = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okMessage)
            present(alert,animated: true, completion: nil)
        }
    
    func resetPasswordAlertMessage() {
        UserDefaults.standard.set(self.mailAddress.text!, forKey: "emailString")
        let alert = UIAlertController(title: "確認", message: "パスワードの再設定をしますか？", preferredStyle: UIAlertController.Style.alert)
        let resetMessage = UIAlertAction(title: "再設定", style: UIAlertAction.Style.default)
        { _ in
            self.performSegue(withIdentifier: "resetPassword", sender: nil)
        }
        let calcelMessage = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: nil)
        
        
        alert.addAction(calcelMessage)
        alert.addAction(resetMessage)
        present(alert,animated: true, completion: nil)
    }
    
    private func mailAddressSetup(){
        mailAddress.layer.cornerRadius = 10
        mailAddress.layer.borderColor = UIColor.black.cgColor
        mailAddress.layer.shadowColor = UIColor.black.cgColor
        mailAddress.layer.shadowOffset = CGSize(width: 0, height: 1)
        mailAddress.layer.shadowOpacity = 0.2
        mailAddress.layer.shadowRadius = 1
    }
    
    private func passwordSetup(){
        passWord.layer.cornerRadius = 10
        passWord.layer.borderColor = UIColor.black.cgColor
        passWord.layer.shadowColor = UIColor.black.cgColor
        passWord.layer.shadowOffset = CGSize(width: 0, height: 1)
        passWord.layer.shadowOpacity = 0.2
        passWord.layer.shadowRadius = 1
    }
    
    private func loginButtonSetup(){
        loginButton.layer.cornerRadius = 23
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        loginButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowRadius = 1
    }

}

