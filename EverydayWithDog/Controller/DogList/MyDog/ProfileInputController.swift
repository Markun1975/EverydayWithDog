//
//  ProfileInputController.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class ProfileInputController: FormViewController{
    let FormVC = FormViewController()
    
    let dogInfoArray = [DogInfo]()
    
        var profileImg:UIImage?//ワンちゃんプロフィール写真
        var name:String? = ""//ワンちゃんの名前"
        var sex:String? = ""//ワンちゃんの性別
        var dogType:String? = ""//犬種
        var date:Date?
        var birthString:String? = ""
        var chipId:String? = ""//ICチップ番号
        var contraception:String? = ""//避妊有無
        var personality:String? = ""//性格
        var rabies:String? = ""//狂犬病予防接種有無
        var filaria:String? = ""//フェラリア予防ゆ有無
        var memo:String? = ""//メモ
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input()
        
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func input(){
        
            form
                //ヘッダー設定も可能
                //ヘッダー　高さで変えられるよ！
//                            +++ Section() {
//                            $0.header = {
//                                let header = HeaderFooterView<UIView>(.callback({
//                                    let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
//        //                            let image1 = UIImage(named: "heli") // (1)
//        //                            let imageView = UIImageView(image:image1)   // (2)
//        //                            view.addSubview(imageView)  // (3)
//                                    return view
//                                }))
//                                return header
//                            }()
//                        }
                //写真に選択フォーム
                    +++ Section("写真")
                    <<< ImageRow() {
                        $0.title = "画像"
                        $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                        $0.clearAction = .yes(style: .destructive)
                        $0.onChange { [unowned self] row in
                            self.profileImg = row.value!
                        }
                    }
                    //名前入力フォーム
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
                //性別入力フォーム
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
                
                //犬種入力フォーム
                    <<< PickerInlineRow<String>() { row in
                        row.title = "犬種"
                        row.title = "犬種"
                        row.options =  ["柴犬","ミニチュアダックスフンド","ゴールデンレトリバー","ラブラドールレトリバー","秋田犬","ブルドッグ","トイプードル","パグ","シベリアンはハスキー","ポメラニアン","プードル","チワワ","ビーグル","マルチーズ","パピヨン"]

                        row.value = row.options.first
                    }.onChange { [unowned self] row in
//                        self.selectedDogType = row.value!
//                        print(self.selectedDogType)
                        self.dogType! = row.value!
                        print(self.dogType!)
                }
                //誕生日入力フォーム
                    <<< DateRow("") {
                        $0.title = "誕生日を選択"
                    }.onChange() { row in
                        //Date型をString型に変換
//                        var date = Date()
//                        date = row.value!
                        let formatter = DateFormatter()
                        formatter.dateStyle = .long
                        formatter.timeStyle = .none
                        if row.value != nil{
                        self.date = row.value
                        self.birthString = formatter.string(from: self.date!)
                        print(formatter.string(from: self.date!))
                        }
                        else{
                            print("誕生日エラー")
                        }
                }
                
                //チップID入力フォーム
                    <<< TextRow { row in
                        row.title = "チップID"
                        row.placeholder = "IDを入力"
                    }.onChange{ row in
                        if row.value != nil {
                        self.chipId! = row.value!
                        print(self.chipId!)
                        }else{
                            self.chipId = "ID無し"
                            print("ID無し")
                        }
                    }
                

              
                +++ Section("その他追加情報")
                //避妊有無フォーム
                <<< PickerInlineRow<String>() { row in
                        row.title = "避妊有無"
                        row.options =  ["あり","なし"]
                        row.value = row.options.first
                    }.onChange { [unowned self] row in
//                        self.selectedDogType = row.value!
//                        print(self.selectedDogType)
                        self.contraception! = row.value!
                        print(self.contraception!)
                }
                //性格入力フォーム
                <<< PickerInlineRow<String>() { row in
                        row.title = "性格"
                        row.options =  ["人懐っこい","活発","おとなしい","臆病","怒りっぽい"]
                        row.value = row.options.first
                    }.onChange { [unowned self] row in
//                        self.selectedDogType = row.value!
//                        print(self.selectedDogType)
                        self.personality! = row.value!
                        print(self.personality!)
                }
                    
                +++ Section("病気予防")
                //狂犬病予防接種フォーム
                <<< PickerInlineRow<String>() { row in
                        row.title = "狂犬病予防接種"
                        row.options =  ["あり","なし"]
                        row.value = row.options.first
                    }.onChange { [unowned self] row in
//                        self.selectedDogType = row.value!
//                        print(self.selectedDogType)
                        self.rabies! = row.value!
                        print(self.rabies!)
                }
                //フェラリア予防接種フォーム
                <<< PickerInlineRow<String>() { row in
                        row.title = "フェラリア予防"
                        row.options =  ["あり","なし"]
                        row.value = row.options.first
                    }.onChange { [unowned self] row in
//                        self.selectedDogType = row.value!
//                        print(self.selectedDogType)
                        self.filaria! = row.value!
                        print(self.filaria!)
                        
                }
                
                +++ Section ("その他メモ")
                //メモ入力フォーム
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
        
                //登録ボタン
                <<< ButtonRow { row in
                    row.title = "ワンちゃんを登録"
                }.onCellSelection({ (cell, row) in
                    self.checkAlert()
                }).cellSetup ({ (cell, row)in
                    cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        })
                
            }
func upLoadData(){
("upLoadData呼ばれてる！")
        var ref: DatabaseReference!
        //ユーザーID取得
        let uid = Auth.auth().currentUser?.uid
    
        //FirebaseFirestoreにUserコレクションをその配下にはuidをその配下にはdogListを定義
            let doglistDB = Firestore.firestore().collection("user").document(uid!).collection("dogList").document()
            
        //ワンコの写真をStorageに保存する場所を定義
            let storage = Storage.storage().reference(forURL: "gs://everydaywithdog.appspot.com")
            print("Database定義の最初の通信OK")
            
        //ワンコのプロフィールをDBに保存するKey値を定義
            let key = doglistDB.collection("user").document(uid!).collection("dogList").document().documentID
            let imgRef = storage.child("DogPlofile").child("\(String(describing: key)).jpeg") //ワンコプロフィール写真のJPEG型
        
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
                        let dogListInfo = ["dogName":self.name as Any,"dogProfileImage":url? .absoluteString as Any,"dogSex":self.sex as Any,"dogType":self.dogType as Any,"dogBirth":self.birthString as Any,"chipId":self.chipId as Any,"dogContraception":self.contraception as Any,"dogPersonality":self.personality as Any,"dogRabies":self.rabies as Any,"dogFilaria":self.filaria as Any,"dogMemo":self.memo as Any,"postDate":Timestamp()] as [String:Any]
                        //iPhone側からFirebaseDataBaseの側へ犬の情報を全て送信 //下記が完了した時点でデータベースに入っているということ
                        doglistDB.setData(dogListInfo)
                        print("ワンコのデータ登録完了")
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
        } else if self.birthString == nil{
                   displayAlertMessage(userMesage: "誕生日を入力してください")
        } else if self.chipId == nil{
                   displayAlertMessage(userMesage: "チップIDが入力されていません")
            self.chipId = "チップIDなし"
        } else if self.contraception == nil{
                          displayAlertMessage(userMesage: "避妊手術の有無を入力してください")
        } else if self.personality == nil{
                          displayAlertMessage(userMesage: "性格の入力をしてください")
        } else if self.rabies == nil{
            displayAlertMessage(userMesage: "狂犬病予防接種情報の入力も必須です")
        } else if self.filaria == nil{
            displayAlertMessage(userMesage: "フェラリア予防情報を入力してください")
        } else if self.memo == nil{
            self.memo = "なし"
        }else{
            print("必要事項記入はOK")
            upLoadData()
            self.performSegue(withIdentifier: "upLoad", sender: nil)
        }
    }
}



