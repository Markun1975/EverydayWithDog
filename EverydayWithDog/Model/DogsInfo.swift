//
//  DogsInfo.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class DogInfo {

    
    var dogID = "" //Firestoreの犬のドキュメントID
    var profileImgString = ""//ワンちゃんプロフィール写真
    var nameString:String = "" //ワンちゃんの名前"
    var sexString:String = "" //ワンちゃんの性別
    var dogTypeString:String = "" //犬種
    var birthString:String = ""
//    var birth:  = 0 //誕生日
    var chipIdString:String = "" //ICチップ番号
    var contraceptionString:String = "" //避妊有無
    var personalityString:String = "" //性格
    var rabiesString:String = "" //狂犬病予防接種有無
    var filariaString:String = "" //フェラリア予防ゆ有無
    var memoString:String = "" //メモ
    var inputDateString = "" //入力日時
    
    init(dogID:String,profileImgString:String,nameString:String,sexString:String,dogTypeString:String,birthString:String,chipIdString:String,contraceptionString:String, personalityString:String,rabiesString:String,filariaString:String,memoString:String,inputDateString:String){
        
        self.dogID = dogID
        self.profileImgString = profileImgString
        self.nameString = nameString
        self.sexString = sexString
        self.dogTypeString = dogTypeString
        self.birthString = birthString
        self.chipIdString = chipIdString
        self.contraceptionString = contraceptionString
        self.personalityString = personalityString
        self.rabiesString = rabiesString
        self.filariaString = filariaString
        self.memoString = memoString
        self.inputDateString = inputDateString
    }
}
