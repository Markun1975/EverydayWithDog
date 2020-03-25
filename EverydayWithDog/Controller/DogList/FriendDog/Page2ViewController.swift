//
//  Page2ViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import SegementSlide
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class Page2ViewController: UITableViewController,SegementSlideContentScrollViewDelegate {
    
    var aFriendArray = [FriendsInfo]()
    
    let profileVC = ProfileViewController()
    
    var viewNumber = 1
        

        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.title = "FriendDogs List"
        }
    @objc func addFriendButton(){
         self.performSegue(withIdentifier: "addFriend", sender: nil)
     }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return aFriendArray.count
        }
        
        //numberOfRowsInSectionの数だけセルが呼ばれる
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            
            //犬のプロフィール写真の取得
    //        cell.imageView?.sd_setImage(with: URL(string: dogInfoArray[indexPath.row].profileImgString), completed: nil)
            
            //名前を表示
            cell.textLabel?.text = self.aFriendArray[indexPath.row].friendNameString

            //画像の角を丸めて丸みを
            // cell.imageView?.layer.cornerRadius = view.frame.height / 2
            // cell.imageView?.layer.masksToBounds = true
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return view.frame.size.height/6
        }
        
        //セルがタップされたときに画面遷移を行う
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storybordA: UIStoryboard = UIStoryboard(name: "ProfileInput", bundle: nil)
            
            let dogInfomation = aFriendArray[indexPath.row]
            
            UserDefaults.standard.set(dogInfomation.friendImgString, forKey: "friendDogProfileImage")
            UserDefaults.standard.set(dogInfomation.friendNameString, forKey: "friendDogName")
            UserDefaults.standard.set(dogInfomation.friendSexString, forKey: "friendDogSex")
            UserDefaults.standard.set(dogInfomation.friendDogTypeString, forKey: "friendDogType")
            UserDefaults.standard.set(dogInfomation.friemdMemoString, forKey: "friendDogMemo")
            
            let friendVC = storybordA.instantiateViewController(withIdentifier: "friendProfileView")
            self.present(friendVC, animated: true, completion: nil)
            
            //選択状態を解除しておく
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let number = 1
            NotificationCenter.default.post(name: Notification.Name("viewNumber"), object: nil, userInfo: ["viewnumber" : number])
            view.frame.size.height/6
            fetchFriendsDogData()
        }
        
        
        func fetchFriendsDogData() {
            //データベースから犬の情報を取得する　referenceする
            //インプット（登録ボタン）押したときに登録した、Key値("dogList")を使って情報を取得する
            let uid = Auth.auth().currentUser?.uid
            let fetchDogInfo =  Firestore.firestore().collection("user").document(uid!).collection("friendList")
            fetchDogInfo.getDocuments() { snapShot, err in
                
                self.aFriendArray.removeAll()
                guard let documents = snapShot?.documents else {
                    print("snapShotがerrですよ！")
                    return
                }
                
                    for snap in documents {
                        if let postData = snap.data() as? [String: Any]{
                            //String型で保存していたものを取り出す
                            
                            let dogID = snap.documentID
                            
                            let nameData = postData["friendDogName"] as? String
                            print(nameData!)
                            
                            let iconData = postData["friendDogProfileImage"] as? String
                            
                            let sexData = postData["friendDogSex"] as? String
                            
                            let typeData = postData["friendDogType"] as? String
                            
                            let memoData = postData["dogMemo"] as? String
                            
                            let postDate:Timestamp? = postData["postDate"] as? Timestamp
                            
                            //postDateをを時間に変換する
                            let timeString = postDate?.dateValue()
                            let f = DateFormatter()
                                     f.locale = Locale(identifier: "ja_JP")
                                     f.dateStyle = .long
                                     f.timeStyle = .none
                                     let date = f.string(from: timeString!)
                            
                            self.aFriendArray.append(FriendsInfo(friendDogID: dogID, friendImgString: iconData!, friendNameString: nameData!, friendSexString: sexData!, friendDogTypeString: typeData!, friendMemoString: memoData!, friendInputDateString: date))
                    }
                        //読み込みが終わったタイミングですぐにTableViewにリロードして反映
                        self.tableView.reloadData()
                }
            }
        }
    }

