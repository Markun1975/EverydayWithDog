//
//  DogListViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SegementSlide
import SDWebImage

class DogListViewController: SegementSlideDefaultViewController{
    
    
    @IBOutlet var DogList: UIView!
    
    var viewnumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .white
        
        //必須
        reloadData()
        defaultSelectedIndex = 0
        
        //NavigationBar設定
        self.navigationController?.navigationBar.isTranslucent = false //くもりガラスを取る
        self.navigationController?.navigationBar.shadowImage = UIImage() //下線を消去
        self.navigationController?.navigationBar.titleTextAttributes
        = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
           .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(red: 242/255, green: 87/255, blue: 129/255, alpha: 1)
        
        //NavigationButton設定
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "account"), style: .done, target: self, action: #selector(settingNavigation))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(buttonNavigation))
        
            NotificationCenter.default.addObserver(self,selector: #selector(catchSelectMenuNotification(notification:)),name: Notification.Name("viewNumber"),object: nil)
        
        //TabBar設定
          self.tabBarController?.tabBar.barTintColor = UIColor.white
          self.tabBarController?.tabBar.tintColor = UIColor(red: 242/255, green: 87/255, blue: 129/255, alpha: 1)
          self.tabBarController?.tabBar.layer.borderWidth = 0.5
          self.tabBarController?.tabBar.layer.borderColor = UIColor.gray.cgColor
          self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
          self.tabBarController?.tabBar.layer.shadowRadius = 4.0
          self.tabBarController?.tabBar.layer.shadowOpacity = 0.6
          self.tabBarController?.tabBar.clipsToBounds = true
    }
    

    
    override var titlesInSwitcher: [String]{
        return ["My Dog","Friend Dogs"]
    }

    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch index {
        case 0:
            return Page1ViewController()
        case 1:
            return Page2ViewController()
        default: return Page1ViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
   @objc func buttonNavigation(){
        if viewnumber == 0 {
            //追加画面へ
            self.performSegue(withIdentifier: "addDog", sender: nil)
        } else if viewnumber == 1 {
            self.performSegue(withIdentifier: "addFriend", sender: nil)
        }
    }
    
    @objc func settingNavigation(){
        self.performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    // 表示されているViewのViewNumberアイテムを取得
    @objc func catchSelectMenuNotification(notification: Notification) -> Void {
          // メニューからの返り値を取得
           self.viewnumber = notification.userInfo!["viewnumber"] as! Int // 返り値が格納されている変数
           print(self.viewnumber, "viewnumber変更できました")
              // 実行したい処理を記述する
          }
}
