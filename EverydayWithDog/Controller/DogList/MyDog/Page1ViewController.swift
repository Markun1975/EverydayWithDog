//
//  Page1ViewController.swift
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


class Page1ViewController: UITableViewController,SegementSlideContentScrollViewDelegate {
    
    var dogInfoArray = [DogInfo]()
    
    let profileVC = ProfileViewController()
    
    let page2 = Page2ViewController()
    
    var viewNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "MyDogs List"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogInfoArray.count
        
    }
    
    //numberOfRowsInSectionの数だけセルが呼ばれる
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        //名前を表示
        cell.textLabel?.text = self.dogInfoArray[indexPath.row].nameString
        
        //犬のプロフィール写真の取得後に実装
         // cell.imageView?.sd_setImage(with: URL(string: dogInfoArray[indexPath.row].profileImgString), completed: nil)

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
        
        let dogInfomation = dogInfoArray[indexPath.row]
        //セルをタップしたときにプロフィール表示に必要な情報(文字列を保存する)
        UserDefaults.standard.set(dogInfomation.profileImgString, forKey: "imageString")
        UserDefaults.standard.set(dogInfomation.nameString, forKey: "name")
        UserDefaults.standard.set(dogInfomation.sexString, forKey: "sex")
        UserDefaults.standard.set(dogInfomation.dogTypeString, forKey: "type")
        UserDefaults.standard.set(dogInfomation.birthString, forKey: "birth")
        UserDefaults.standard.set(dogInfomation.chipIdString, forKey: "chipId")
        UserDefaults.standard.set(dogInfomation.contraceptionString, forKey: "contraception")
        UserDefaults.standard.set(dogInfomation.personalityString, forKey: "personality")
        UserDefaults.standard.set(dogInfomation.rabiesString, forKey: "rabies")
        UserDefaults.standard.set(dogInfomation.filariaString, forKey: "filaria")
        UserDefaults.standard.set(dogInfomation.memoString, forKey: "memo")
        
        let friendVC = storybordA.instantiateViewController(withIdentifier: "profileView")
        self.present(friendVC, animated: true, completion: nil)
        
        //選択状態を解除しておく
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDogData()
        
        //設定画面に行った時に友達犬の数も送るため、ここでfetchしている
        page2.fetchFriendsDogData()
        //ViewNumber化してPage1と2でNavigationButtonのタップ後の処理を分岐
        let number = 0
        NotificationCenter.default.post(name: Notification.Name("viewNumber"), object: nil, userInfo: ["viewnumber" : number])
    }
    
    
    func fetchDogData() {
        //データベースから犬の情報を取得する　referenceする
        //インプット（登録ボタン）押したときに登録した、Key値("dogList")を使って情報を取得する
        let uid = Auth.auth().currentUser?.uid
        let fetchDogInfo =  Firestore.firestore().collection("user").document(uid!).collection("dogList")
        fetchDogInfo.getDocuments() { snapShot, err in
            
            self.dogInfoArray.removeAll()
            guard let documents = snapShot?.documents else {
                print("snapShotがerrですよ！")
                return
            }
                for snap in documents {
                    if let postData = snap.data() as? [String: Any]{
                        //String型で保存していたものを取り出す
                        let nameData = postData["dogName"] as? String
                        
                        let iconData = postData["dogProfileImage"] as? String
                        
                        let sexData = postData["dogSex"] as? String
                        
                        let typeData = postData["dogType"] as? String
                        
                        let birthData = postData["dogBirth"] as? String
                        
                        let chipData = postData["chipId"] as? String
                        
                        let contraceptionData = postData["dogContraception"] as? String
                        
                        let personalityData = postData["dogPersonality"] as? String
                        
                        let rabiesData = postData["dogRabies"] as? String
                        
                        let filariaData = postData["dogFilaria"] as? String
                        
                        let memoData = postData["dogMemo"] as? String
                        
                        let postDate:Timestamp? = postData["postDate"] as? Timestamp
                        
                        
                        let dogID = snap.documentID
                        

                        //postDateをを時間に変換する
                        let timeString = postDate?.dateValue()
                        let f = DateFormatter()
                                 f.locale = Locale(identifier: "ja_JP")
                                 f.dateStyle = .long
                                 f.timeStyle = .none
                                 let date = f.string(from: timeString!)
                        
                        self.dogInfoArray.append(DogInfo(dogID: dogID,profileImgString: iconData!, nameString: nameData!, sexString: sexData!, dogTypeString: typeData!, birthString: birthData!, chipIdString: chipData!, contraceptionString: contraceptionData!, personalityString: personalityData!, rabiesString: rabiesData!, filariaString: filariaData!, memoString: memoData!, inputDateString: date))
                }
                    //読み込みが終わったタイミングですぐにTableViewにリロードして反映
                    self.tableView.reloadData()
            }
            //セルの数をカウント(犬の数)
            let dogCounts =  String(self.dogInfoArray.count)
            print(dogCounts)
            UserDefaults.standard.set(dogCounts, forKey: "dogcounts")
        }
    }
}
