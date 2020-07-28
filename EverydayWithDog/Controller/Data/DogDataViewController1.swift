//
//  DogDataViewController1.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SegementSlide
import SideMenu
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class DogDataViewController1: SegementSlideDefaultViewController{
    
    let fetchFirstDogIdInfo = FetchDogData()
    
    let uid = Auth.auth().currentUser?.uid
    
    
    var dogNamelabel = UILabel()
    
    var dogID:String?
    var dogsName:String?
    
    override func viewWillAppear(_ animated: Bool) {
    //画面表示初期の名前を表示
    fetchFirstDogIdInfo.fetchFirstDogId()
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.setNavigationBarHidden(false, animated: true)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dogsName = UserDefaults.standard.object(forKey: "dogFirstName") as? String
        if self.dogsName != nil {
        self.dogNamelabel.text = self.dogsName
        } else {
            self.dogNamelabel.text = "登録なし"
        }

        //NavigationBar設定
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes
               = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
                  .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "pets"), style: .done, target: self, action: #selector(selectDog))
        
        //NavigationBar BacgroundColor
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        //アイコンの色
        self.navigationController?.navigationBar.tintColor = UIColor(red: 242/255, green: 87/255, blue: 129/255, alpha: 1)
        
        //下記コード必ず必要
        reloadData()
        defaultSelectedIndex = 0
        
        //TabBar設定
       self.tabBarController?.tabBar.barTintColor = UIColor.white
       self.tabBarController?.tabBar.tintColor = UIColor(red: 242/255, green: 87/255, blue: 129/255, alpha: 1)
       self.tabBarController?.tabBar.layer.borderWidth = 0.5
       self.tabBarController?.tabBar.layer.borderColor = UIColor.gray.cgColor
       self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
       self.tabBarController?.tabBar.layer.shadowRadius = 4.0
       self.tabBarController?.tabBar.layer.shadowOpacity = 0.6
       self.tabBarController?.tabBar.clipsToBounds = true
        
        //DogListSideViewの選択した犬の名前を取得反映
        NotificationCenter.default.addObserver(
        self,selector: #selector(selectNameNotification(notification:)),name:Notification.Name("dataDogNAME"),object: nil)
        
        // サイドバーメニューからの通知を受け取る
        NotificationCenter.default.addObserver(
        self,selector: #selector(selectIdNotification(notification:)),name:Notification.Name("dataDogID"),object: nil)
        
        //SegementSlideViewのAutoLayout
        self.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        print("DogdataViewメイン読み込み")
    }
    
    override var titlesInSwitcher: [String] {
        return ["食事", "お水", "運動", "トイレ"]
    }
    
    
     override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
                switch index {
                case 0:
                    return MealDataTableViewController1()
                case 1:
                    return WaterDataTableViewController1()
                case 2:
                    return WalkDataTableViewController1()
                case 3:
                    return ToiletDataTableViewController1()
                default: return MealDataTableViewController1()
                }
        
            }
    
    
    override func segementSlideHeaderView() -> UIView? {
        
        let headerView = UIView()

         
         headerView.isUserInteractionEnabled = false
         headerView.translatesAutoresizingMaskIntoConstraints = false
         let headerHeight:CGFloat
         if #available(iOS 11.0, *){
             headerHeight = view.bounds.height/14 + view.safeAreaInsets.top
         }else{
             headerHeight = view.bounds.height/14 + topLayoutGuide.length
         }
         headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: headerHeight)
         headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
         
         //NameLabelの設定
         dogNamelabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/16)
         dogNamelabel.textAlignment = NSTextAlignment.center
         dogNamelabel.font = UIFont.boldSystemFont(ofSize: 20)
         dogNamelabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
         headerView.addSubview(dogNamelabel)
         
         return headerView
    }
    
    
    @objc func selectDog(){
        let SideMenu = DataSideMenu()
                  let menu = SideMenuNavigationController(rootViewController: SideMenu)
                  SideMenuManager.default.leftMenuNavigationController = menu
                  SideMenuManager.default.addPanGestureToPresent(toView: menu.navigationBar)
                  SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: menu.view)
                  present(menu, animated: true, completion: nil)
    }

    
    //    // 選択されたサイドバーのアイテムを取得
    @objc func selectNameNotification(notification: Notification) -> Void {
     // メニューからの返り値を取得
     self.dogsName = notification.userInfo!["dataDogName"] as! String //dogsNameの返り値が格納されている変数
     print(self.dogsName!, "親Viewで名前変更できました")
     
     // 実行したい処理を記述する
    self.dogNamelabel.text = self.dogsName
    }
    
    @objc func selectIdNotification(notification: Notification) -> Void {
        //dogsIdの返り値が格納されている変数
        self.dogID = notification.userInfo!["dataDogId"] as! String // 返り値が格納されている変数
        print(self.dogID! as Any, "親ViewでDogID変更取得できました")
    }
    
    func SegementAutoLayout(){
//        let view1 = DogDataViewController1()
        
    }
}
