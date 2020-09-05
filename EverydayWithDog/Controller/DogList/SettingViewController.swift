//
//  SettingViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 4/21/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingViewController: UIViewController {
    
    @IBOutlet var userIdLabel: UILabel!
    
    @IBOutlet var myDogNumber: UILabel!
    
    @IBOutlet var friendDogsNumber: UILabel!
    
    @IBOutlet var LogOutButton: UIButton!
    
    
    @IBOutlet var exit: UIButton!
    
    @IBOutlet var centerLabel: UILabel!
    
    
    @IBOutlet var baseTopView: UIView!
    
    
    @IBOutlet var baseCenterView: UIView!
    
    var userEmail:String?
    
    var myDogCounts:String?
    
    var uid = Auth.auth().currentUser?.uid
    
    let user = Auth.auth().currentUser
    
    let topStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView(baseView: baseTopView)
        baseView(baseView: baseCenterView)

        //navigationbar 下部のY座標が変わってしまうのを防ぐために設定
        self.navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
        
        centerLabel.layer.borderWidth = 1
        centerLabel.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.26).cgColor
        
        
        if user == nil {
            print("nowUser取得エラー")
        } else {
            self.userEmail = user?.email
            self.userIdLabel.text = self.userEmail
        }
        
        self.myDogNumber.text = UserDefaults.standard.object(forKey: "dogcounts") as? String
        self.friendDogsNumber.text = UserDefaults.standard.object(forKey: "friendDogcounts") as? String
        
        LogOutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        exit.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func logOutProgress(_ sender: Any) {
        do {
            try Auth.auth().signOut()
           } catch let error {
               print(error)
           }
        uid = nil
        let topVC = topStoryboard.instantiateViewController(identifier: "LoginView")
        self.show(topVC, sender: self)
    }
    
    
    
    
    @IBAction func withdrawalProgress(_ sender: Any) {
        //部品のアラートを作る
        let withdrawalCheckAlertController = UIAlertController(title: "退会の確認", message: "退会するとすべてのログと情報が見れなくなります", preferredStyle: UIAlertController.Style.alert)
        
        //キャンセル
        let withdrawalCheckCanceAction = UIAlertAction(title: "キャンセル", style: .default) { _ in
        withdrawalCheckAlertController.dismiss(animated: true, completion: nil)
        print("キャンセル")
        }

         //退会確認ボタン
        let withdrawalOKAction = UIAlertAction(title: "OK", style: .default) { _ in
            withdrawalCheckAlertController.dismiss(animated: true, completion: nil)
            self.withdrawalAlertController()
        }
        
        withdrawalCheckAlertController.addAction(withdrawalCheckCanceAction)
        withdrawalCheckAlertController.addAction(withdrawalOKAction)
        self.present(withdrawalCheckAlertController, animated: true, completion: nil)
    }
        
        
    func baseView(baseView: UIView){
        var baseview = UIView()
        baseview = baseView
        
        baseView.layer.cornerRadius = self.view.bounds.width/20
        baseView.layer.shadowColor = UIColor.gray.cgColor
        baseView.layer.shadowOffset = CGSize(width: 0, height: 1)
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowRadius = 0.1
    }
    
    
    private func withdrawalAlertController() {
        
        var checkPassword:String?
        var uiText = UITextField()
        
        let withdrawalAlertController = UIAlertController(title: "退会処理", message: "退会するにはパスワードの入力が必要です", preferredStyle: UIAlertController.Style.alert)
        
        withdrawalAlertController.addTextField { (textField) in
            textField.placeholder = "パスワードを入力してください"
            uiText = textField
            }
        
        //退会ボタン
        let withdrawalAction = UIAlertAction(title: "会員削除", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
            checkPassword = uiText.text!
            
            if checkPassword == nil || checkPassword == "" {
                self.checkPasswordAlertController(title: "パスワード未入力", message: "パスワードが入力されていません")
                print("パスワードを入力してください!")
            } else {
            
            //しばらくログインしてない場合は再度ログインをさせて削除しなければならない(Firebaseの特性上)
            if Auth.auth().currentUser != nil {
                let credential = EmailAuthProvider.credential(withEmail: self.userEmail!, password: checkPassword!)
                self.user?.reauthenticate(with: credential, completion: { authResult, error in
                    if error != nil {
                        print("パスワードが間違っている可能性がある")
                        withdrawalAlertController.dismiss(animated: true, completion: nil)
                        self.checkPasswordAlertController(title: "パスワード再入力", message: "パスワードが間違っています")
                    } else if error == nil {
                        Auth.auth().currentUser?.delete {  (error) in
                                // エラーが無ければ、ログイン画面へ戻る
                                if error == nil {
                                    let topView = self.topStoryboard.instantiateViewController(identifier: "LoginView")
                                    self.show(topView, sender: self)
                                }else{
                                    print("エラー：\(String(describing: error?.localizedDescription))")
                                }
                            }
                    }
                })
                print("currentUser = nil")
            }
            }
            print("退会アクション終わり")
        })//退会アクション終わり
        
        
        
        let withdrawalCanceAction = UIAlertAction(title: "キャンセル", style: .default) { _ in
        withdrawalAlertController.dismiss(animated: true, completion: nil)
        print("キャンセル")
        }
        
        
        withdrawalAlertController.addAction(withdrawalCanceAction)
        withdrawalAlertController.addAction(withdrawalAction)
        self.present(withdrawalAlertController, animated: true, completion: nil)
    }
    
    
    private func checkPasswordAlertController(title: String,message: String) {
        let titleString = title
        let messageString = message
        
        let passCheckAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
        
        //再入力へアクション
        let reInputPassAction = UIAlertAction(title: "再入力", style: .default, handler:{(action: UIAlertAction!) in
            passCheckAlertController.dismiss(animated: true, completion: nil)
            self.withdrawalAlertController()
        })
        //キャンセル
        let reInputPassCancelAction = UIAlertAction(title: "キャンセル", style: .default, handler:{(action: UIAlertAction!) in
            passCheckAlertController.dismiss(animated: true, completion: nil)
        })
        
        passCheckAlertController.addAction(reInputPassCancelAction)
        passCheckAlertController.addAction(reInputPassAction)
        self.present(passCheckAlertController, animated: true, completion: nil)
        
        
    }
    
    
}
