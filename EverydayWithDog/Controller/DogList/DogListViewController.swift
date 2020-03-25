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

class DogListViewController: SegementSlideViewController{
    
    @IBOutlet var DogList: UIView!
    
    var viewnumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        scrollToSlide(at: 0, animated: true)
        
        //NavigationBar設定
        self.navigationItem.title = "わんこリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "追加", style: .done, target: self, action: #selector(buttonNavigation))
        
        //ナヴィゲーションバーの犬追加ボタン設定
        NotificationCenter.default.addObserver(
            self,selector: #selector(catchSelectMenuNotification(notification:)),name: Notification.Name("viewNumber"),object: nil)
        scrollToSlide(at: 0, animated: true)
    }
    
    override var titlesInSwitcher: [String]{
              return["My Dogs","Friends"]
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
    
    // 表示されているViewのViewNumberアイテムを取得
    @objc func catchSelectMenuNotification(notification: Notification) -> Void {
          // メニューからの返り値を取得
           self.viewnumber = notification.userInfo!["viewnumber"] as! Int // 返り値が格納されている変数
           print(self.viewnumber, "viewnumber変更できました")
              // 実行したい処理を記述する
          }
}
