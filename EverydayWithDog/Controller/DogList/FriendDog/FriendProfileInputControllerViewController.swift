//
//  FriendProfileInputControllerViewController.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/9/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Photos
import Eureka
import ImageRow
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class FriendProfileInputControllerViewController: FormViewController{
    let FormVC = FormViewController()
    
    let friendInfoArray = [FriendsInfo]()
    
        var profileImg:UIImage?//ワンちゃんプロフィール写真
        var name:String? = ""//ワンちゃんの名前"
        var sex:String? = ""//ワンちゃんの性別
        var dogType:String? = ""//犬種
        var memo:String? = ""//メモ
        var date:Date?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input()
        
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationItem.backBarButtonItem?.title = "戻る"
        
//        photoOfProfile()
        
    }

    
    
    func input(){
               form


                    //フレンド写真登録フォーム
                    +++ Section("写真")
                    <<< ImageRow() {
                       $0.sourceTypes = [.Camera,.PhotoLibrary]
                       $0.clearAction = .no
                       $0.onChange { [unowned self] row in
                       self.profileImg = row.value!
                       }
                    }
                    
                   //フレンド名前登録
                    +++ Section("お名前")
                    <<< TextRow("NameTag") { row in
                               row.title = "お名前"
                               row.placeholder = "名前を入力"
                           }.onChange{ row in
//                               let value = row.value
//                               print(value!)
                            if row.value != nil{
                                self.name = row.value
                                print(self.name!)
                            } else {
                                self.name = "なし"
                                print("名前無し")
                            }
                }
                    
                    
                    +++ Section("その他情報")
                //フレンド性別入力フォーム
                    <<< SegmentedRow<String>("Sex") { row in
                        row.title = "性別"
                        row.options = ["男の子","女の子"]
                        row.value = "Men"
                    }.onChange { [unowned self] row in
//                        self.sex = row.value ?? "選択なし"
//                        print(self.sex)
                        self.sex! = row.value!
                        print(self.sex!)
                        if self.sex == ""{
                            self.sex = "男の子"
                        }
                        
                    }
        //        +++ Section("犬種")
                    //フレンド犬種入力フォーム
                    <<< PickerInlineRow<String>() { row in
                        row.title = "犬種"
                        row.title = "犬種"
                        row.options =  ["柴犬","ミニチュアダックスフンド","ゴールデンレトリバー","ラブラドールレトリバー","秋田犬","ブルドッグ","トイプードル","パグ","シベリアンはハスキー","ポメラニアン","プードル","チワワ","ビーグル","マルチーズ","パピヨン"]

                        row.value = row.options.first
                    }.onChange { [unowned self] row in
                        self.dogType! = row.value!
                        print(self.dogType!)
                }
                
                   
                
                +++ Section ("その他メモ")
                //フレンドメモ入力フォーム
                <<< TextAreaRow { row in
                        row.title = "メモ"
                        row.placeholder = "メモを書いてください"
                }.onChange{ row in
                    if row.value != nil {
                    self.memo! = row.value!
                    print(self.memo!)
                    }else{
                    self.memo = "なし"
                    }
                }
        
                //フレンド登録ボタン
                <<< ButtonRow { row in
                    row.title = "ワンちゃんを登録"
                }.onCellSelection({ (cell, row) in
                    self.checkAlert()
                }).cellSetup ({ (cell, row)in
                    cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        })
    }
    
func upLoadData(){
    ("upLoadDataは呼ばれてる！")
        var ref: DatabaseReference!
        //ユーザーID取得
        let uid = Auth.auth().currentUser?.uid
    
        //FirebaseFirestoreにUserコレクションをその配下にはuidをその配下にはdogListを定義
            let friendDogListDB = Firestore.firestore().collection("user").document(uid!).collection("friendList").document()
            
        //ワンコの写真をStorageに保存する場所を定義
            let storage = Storage.storage().reference(forURL: "gs://everydaywithdog.appspot.com")
            print("Database定義の最初の通信OK")
            
        //ワンコのプロフィールをDBに保存するKey値を定義
            let key = friendDogListDB.collection("user").document(uid!).collection("friendList").document().documentID
            let imgRef = storage.child("FriendPlofile").child("\(String(describing: key)).jpeg") //ワンコプロフィール写真のJPEG型
        
        //ワンコの投稿された写真を管理する予定・カメラで撮った写真など//今は使わないよ！
//        let imgFef2 = storage.child("DogImage").child("\(String(describing: key!)).jpeg")

        var dogProfileImageData: Data = Data() //ワンコのプロフィール写真もData型だよという変数を定義
//        var contentImage: Data = Data() //コンテンツのImageはデータ型だよという変数を定義//犬ごとの投稿画像の管理で使うかも
        
        //ワンコの写真が入ってきたときにjpegで１1/100に圧縮　画像をデータ型に変換
        if self.profileImg != nil {
            dogProfileImageData = self.profileImg!.jpegData(compressionQuality: 0.01)!
        }

        //写真をiPhoneからFirebaseStorageへ送る putData=サーバーに置くという意味
        let upLoadTask = imgRef.putData(dogProfileImageData, metadata: nil){
            (metaData, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
        
        //FirebaseStrageからiPhone側に画像のURLを送る
        imgRef.downloadURL { (url, error) in
            
            if url != nil {
                imgRef.downloadURL { (url, error) in
                    
                    if imgRef != nil {
                        print("Firabase通信はOK")
                        //KeyValue型でiPhone側へ送信する準備をする
                        //２つ目の.absoluteStringはurl型をString型に直しているよの意味 urlは少し上の引数プロフィール画像を圧縮したurl型のこと
                        //ワンちゃんの名前〜メモ書きまで全ての項目にKey値を設定して保存する仕組みを作る
                        let friendInfoArray = ["friendDogName":self.name as Any,"friendDogProfileImage":url? .absoluteString as Any,"friendDogSex":self.sex as Any,"friendDogType":self.dogType as Any,"dogMemo":self.memo as Any,"postDate":Timestamp()] as [String:Any]
                        //iPhone側からFirebaseDataBaseの側へ犬の情報を全て送信 //下記が完了した時点でデータベースに入っているということ
                        friendDogListDB.setData(friendInfoArray)
                        print("フレンドワンコのデータ登録完了")
                        //ここに登録完了後の画面遷移処理を書くことも可能
                    }else{
                        print("nil２だよ")
                    }
                }
            }else{
                print("nil１だよ")
            }
        }
    }
        upLoadTask.resume()
}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //画面をタッチしたときにキーボードを閉じたい
//        FormViewController.resignFirstResponder(<#T##self: UIResponder##UIResponder#>)
        }
    
func displayAlertMessage(userMesage: String) {
             let userMessage = ""
             
             let alert = UIAlertController(title: "確認", message: userMessage, preferredStyle: UIAlertController.Style.alert)
             let okMessage = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
             alert.addAction(okMessage)
             
             present(alert,animated: true, completion: nil)
         }
    
    

    func checkAlert(){
        if self.name == nil{
            displayAlertMessage(userMesage: "お名前入力は必須です")
        } else if self.sex == nil{
            displayAlertMessage(userMesage: "性別の入力は必須です")
        } else if self.dogType == nil{
            displayAlertMessage(userMesage: "犬種の入力は必須です")
        } else if self.sex == nil{
            displayAlertMessage(userMesage: "性別の入力は必須です")
        } else if self.memo == nil{
            self.memo = "なし"
        }else{
            print("必要事項記入はOK")
            upLoadData()
            self.performSegue(withIdentifier: "upLoadFriend", sender: nil)
        }
    }
}




