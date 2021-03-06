//
//  newAccountViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
//import FirebaseAuth

class newAccountViewController: UIViewController {
    
    @IBOutlet var mailAddress: UITextField!
    
    @IBOutlet var passWord: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    
    
    
    var error : NSError? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        mailAddressSetup()
        passwordSetup()
        registerButtonSetup()
    }
    
    //ログイン条件設定
    @IBAction func newLogin(_ sender: Any) {
        let email = mailAddress.text ?? ""
        let password = passWord.text ?? ""
//        let name = userName.text ?? ""
        
        if email == "" || password == "" {
            displayAlertMessage(userMesage:"全て入力してください")
            return
        }else {
            signUp(email: email, password: password)
        }
    }
    
    private func signUp(email: String, password: String){
          Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
              guard let self = self else {
                return
            }
            let user = result?.user
            
            guard user == nil else {
                self.sendMail(to: user!)
                return
            }
            self.showError(error)
        }}
    

    private func sendMail(to user: User) {
        user.sendEmailVerification() { [weak self] error in
            guard let self = self else {
                return
            }
            if error == nil {
                self.showSignUpInfo()
                print("ステップ3")
            }else{
            self.showError(error)
            print("エラー３")
            }}
    }
    
    private func showSignUpInfo() {
        //アラートの内容を変更できる
//        displayAlertMessage(userMesage: "メールを送信しましたメールを確認してください")
        print("登録されました")
        
        //部品のアラートを作る
        let alertController = UIAlertController(title: "メール登録確認", message: "メールが送信されました、メールを確認して登録を完了してください。", preferredStyle: UIAlertController.Style.alert)
         //ちなみにUIAlertControllerStyle.alertをactionsheetに変えると下からにょきっと出てくるやつになるよ

        //OKボタン追加
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
       //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             // 0.5秒後に実行したい処理
                self.performSegue(withIdentifier:"loginSuccess", sender: nil)
             }
            }
         )
           alertController.addAction(okAction)
           present(alertController, animated: true, completion: nil)
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
    func errorMessage(of error: Error) -> String {
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
    

    //アラート骨組み
     func displayAlertMessage(userMesage: String) {
                  let alert = UIAlertController(title: "確認", message: userMesage, preferredStyle: UIAlertController.Style.alert)
                  let okMessage = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                  alert.addAction(okMessage)
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
    
    private func registerButtonSetup(){
           registerButton.layer.cornerRadius = 23
           registerButton.layer.shadowColor = UIColor.black.cgColor
           registerButton.layer.shadowOffset = CGSize(width: 0, height: 1)
           registerButton.layer.shadowOpacity = 0.2
           registerButton.layer.shadowRadius = 1
       }
}
