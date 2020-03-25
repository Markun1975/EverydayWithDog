//
//  DogDataViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/13/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SegementSlide
import SideMenu
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore


class DogDataViewController: SegementSlideViewController {
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet var dogNamelabel: UILabel!
    
    var dogID = String()
    var dogsName:String = ""
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            //NameLabelの設定
             dogNamelabel.frame = CGRect(x: (view.frame.size.width/2) - view.frame.size.width/4, y: (headerView?.frame.height)!, width: view.frame.size.width/2, height: 30)
             self.view.addSubview(dogNamelabel)
            
            //下記コード必ず必要
             reloadData()
             scrollToSlide(at: 0, animated: true)
                
            //NavigationBar設定
             self.navigationItem.title = "データ一覧"
             self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dogIcon"), style: .done, target: self, action: #selector(selectDog))
            
            //DogListSideViewの選択した犬の名前を取得反映
             NotificationCenter.default.addObserver(
             self,selector: #selector(selectNameNotification(notification:)),name: Notification.Name("dogNAME"),object: nil)
            
             if self.dogID != nil {
            //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
             let db =  Firestore.firestore().collection("user").document(uid!).collection("dogList").limit(to: 1)
             db.getDocuments() { snapShot, err in
             guard let documents = snapShot?.documents else {
             print("snapShotがerrですよ！")
             return
            }
    //            self.dogNamelabel.text = ""
             for snap in documents {
             if let postData = snap.data() as? [String: Any]{
             let firstDogName = postData["dogName"] as? String
             print(firstDogName!,"TOP画面　初期のDOG NAME")
             self.dogNamelabel.text = firstDogName!
        //                                                self.dataVC.dogNamelabel.text = firstDogName!
        }
       }
      }
     }
    }
        
        override var titlesInSwitcher: [String]{
                  return["食事","お水","散歩","トイレ"]
              }
        
        override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
            switch index {
            case 0:
                return MealDataTableViewController()
            case 1:
                return WaterDataTableViewController()
            case 2:
                return WalkDataTableViewController()
            case 3:
                return ToiletDataTableViewController()
            default: return MealDataTableViewController()
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    
    override var headerView: UIView?{
        let headerView = UIView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleToFill
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerHeight:CGFloat
        if #available(iOS 11.0, *){
            headerHeight = view.bounds.height/20 + view.safeAreaInsets.top
        }else{
            headerHeight = view.bounds.height/20 + topLayoutGuide.length
        }
        headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        return headerView
    }
    
//    // 選択されたサイドバーのアイテムを取得
    @objc func selectNameNotification(notification: Notification) -> Void {

     // メニューからの返り値を取得
     self.dogsName = notification.userInfo!["dogName"] as! String //dogsNameの返り値が格納されている変数
     print(self.dogsName, "親Viewで名前変更できました")
     
     // 実行したい処理を記述する
    self.dogNamelabel.text = self.dogsName
        
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
