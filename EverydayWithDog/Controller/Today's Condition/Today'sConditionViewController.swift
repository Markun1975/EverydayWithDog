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
    
    

    @IBOutlet var ConditionMainView: UIView!
    
    @IBOutlet var mealButton: UIButton!
    @IBOutlet var waterButton: UIButton!
    @IBOutlet var walkButton: UIButton!
    @IBOutlet var toiletButton: UIButton!
    @IBOutlet var dogSelectButton: UIButton!
    
    @IBOutlet var petFoodIcon: UIImageView!
    @IBOutlet var waterIcon: UIImageView!
    @IBOutlet var walkIcon: UIImageView!
    @IBOutlet var toiletIcon: UIImageView!
    
    
    @IBOutlet var TodaysDogName: UILabel!
    
    var dogID = String()
    var dogNAME = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UIButtonセットアップ
        buttonSetup(setEnterBtton: mealButton)
        buttonSetup(setEnterBtton: waterButton)
        buttonSetup(setEnterBtton: walkButton)
        buttonSetup(setEnterBtton: toiletButton)
        
        iconSetup(setButtonIcon: petFoodIcon)
        iconSetup(setButtonIcon: waterIcon)
        iconSetup(setButtonIcon: walkIcon)
        iconSetup(setButtonIcon: toiletIcon)
        
           //NavigationBar設定
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "pets"), style: .done, target: self, action: #selector(selectDog))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 242/255, green: 87/255, blue: 129/255, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes
        = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
           .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)]
        
        
        
        //TabBar設定
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.tintColor = UIColor(red: 242/255, green: 87/255, blue: 129/255, alpha: 1)
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBarController?.tabBar.layer.shadowRadius = 4.0
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.6
        self.tabBarController?.tabBar.clipsToBounds = true
        
        
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
    
    func buttonSetup(setEnterBtton: UIButton){
        
        var setButton = UIButton()
        setButton = setEnterBtton
        setButton.layer.backgroundColor = UIColor.white.cgColor
        setButton.layer.cornerRadius = self.view.bounds.width/15
           setButton.layer.shadowColor = UIColor.black.cgColor
           setButton.layer.shadowOffset = CGSize(width: 0, height: 1)
           setButton.layer.shadowOpacity = 0.2
           setButton.layer.shadowRadius = 1
    }
    
    func iconSetup(setButtonIcon: UIImageView){
        
        var setIcon = UIImageView()
        setIcon = setButtonIcon
        setIcon.layer.shadowColor = UIColor.black.cgColor
        setIcon.layer.shadowOffset = CGSize(width: 0, height: 1)
        setIcon.layer.shadowOpacity = 0.2
        setIcon.layer.shadowRadius = 0.2
      }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        iconCornerRadius()
    }
    
    private func iconCornerRadius(){
        //Icon
        petFoodIcon.layer.cornerRadius = petFoodIcon.frame.height/2
        petFoodIcon.clipsToBounds = true
        waterIcon.layer.cornerRadius = petFoodIcon.frame.height/2
        waterIcon.clipsToBounds = true
        walkIcon.layer.cornerRadius = petFoodIcon.frame.height/2
        walkIcon.clipsToBounds = true
        toiletIcon.layer.cornerRadius = petFoodIcon.frame.height/2
        toiletIcon.clipsToBounds = true
    }
    
//    func iconSetup1(setButtonIcon: UIImageView,setUIButton: UIButton){
//       var setIcon = UIImageView()
//       var setButton = UIButton()
//       setIcon = setButtonIcon
//       setButton = setUIButton
//        
//        setIcon.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(setIcon)
//       
//        
//        setIcon.topAnchor.constraint(equalTo: setButton.topAnchor, constant: 28).isActive = true
//        setIcon.leftAnchor.constraint(equalTo: setButton.leftAnchor, constant: 29.0).isActive = true
//        
//        setIcon.bottomAnchor.constraint(equalTo: setButton.bottomAnchor, constant: 27).isActive = true
//        
//        
//        
//        setIcon.widthAnchor.constraint(equalTo: setIcon.heightAnchor, multiplier: 1.0).isActive = true
//        
//        setIcon.widthAnchor.constraint(equalTo: setIcon.widthAnchor, multiplier: 1.0).isActive = true
//
//        setIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//    }
}

