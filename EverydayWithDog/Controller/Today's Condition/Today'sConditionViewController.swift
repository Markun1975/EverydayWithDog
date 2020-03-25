//
//  Today'sConditionViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class Today_sConditionViewController: UIViewController {
    var tableView: UITableView?
    
    @IBOutlet var mealButton: UIButton!
    @IBOutlet var waterButton: UIButton!
    @IBOutlet var walkButton: UIButton!
    @IBOutlet var toiletButton: UIButton!
    @IBOutlet var dogSelectButton: UIButton!
    
    @IBOutlet var TodaysDogName: UILabel!
    
    var dogID = String()
    var dogNAME = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealButton.layer.cornerRadius = 23
        waterButton.layer.cornerRadius = 23
        walkButton.layer.cornerRadius = 23
        toiletButton.layer.cornerRadius = 23
        
        self.navigationItem.title = "体調管理"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dogIcon"), style: .done, target: self, action: #selector(selectDog))
        
        // サイドバーメニューからの通知を受け取る
        NotificationCenter.default.addObserver(
         self,selector: #selector(catchSelectMenuNotification(notification:)),name: Notification.Name("dogID"),object: nil)
        NotificationCenter.default.addObserver(
        self,selector: #selector(catchSelectNameNotification(notification:)),name: Notification.Name("dogNAME"),object: nil)
        
        //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
        let uid = Auth.auth().currentUser?.uid
        let fetchDogInfo =  Firestore.firestore().collection("user").document(uid!).collection("dogList").limit(to: 1)
        fetchDogInfo.getDocuments() { snapShot, err in
        
                guard let documents = snapShot?.documents else {
                            print("snapShotがerrですよ！")
                            return
                    }
                            for snap in documents {
                                if let postData = snap.data() as? [String: Any]{
                                    self.dogID = snap.documentID
                                    let dogname = postData["dogName"] as? String
                                    print(self.dogID,"初期のDOG　ID")
                                    self.dogNAME = dogname!
                                    self.TodaysDogName.text = dogname!
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // 選択されたサイドバーのアイテムを取得
       @objc func catchSelectMenuNotification(notification: Notification) -> Void {
           // メニューからの返り値を取得
        self.dogID = notification.userInfo!["dogId"] as! String // dogIdの返り値が格納されている変数
        print(self.dogNAME, "変更取得できました")
       }
    
     // 選択されたサイドバーのアイテムを取得
           @objc func catchSelectNameNotification(notification: Notification) -> Void {
            
            // メニューからの返り値を取得
            self.dogNAME = notification.userInfo!["dogName"] as! String //dogNameの返り値が格納されている変数
            print(self.dogNAME, "名前変更できました")
            
            // 実行したい処理を記述する
            TodaysDogName.text = self.dogNAME
           }
    
    @IBAction func toMealInfo(_ sender: Any) {
        UserDefaults.standard.set(self.dogID, forKey: "dogID")
        self.performSegue(withIdentifier: "addMeal", sender: nil)
    }
    
    @IBAction func toWaterInfo(_ sender: Any) {
        UserDefaults.standard.set(self.dogID, forKey: "dogID")
        self.performSegue(withIdentifier: "addWater", sender: nil)
    }
    
    @IBAction func toWalkInfo(_ sender: Any) {
        UserDefaults.standard.set(self.dogID, forKey: "dogID")
        self.performSegue(withIdentifier: "addWalk", sender: nil)
    }
    
    @IBAction func toToiletInfo(_ sender: Any) {
        UserDefaults.standard.set(self.dogID, forKey: "dogID")
        self.performSegue(withIdentifier: "addToilet", sender: nil)
    }
    
    @objc func selectDog(){
        let SideMenu = dogListSideMenuController()
                  let menu = SideMenuNavigationController(rootViewController: SideMenu)
                  SideMenuManager.default.leftMenuNavigationController = menu
                  SideMenuManager.default.addPanGestureToPresent(toView: menu.navigationBar)
                  SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: menu.view)
                  present(menu, animated: true, completion: nil)
    }
}

