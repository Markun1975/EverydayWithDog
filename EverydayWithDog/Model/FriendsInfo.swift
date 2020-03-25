//
//  Friends.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import UIKit
class FriendsInfo {
    
    var friendDogID = "" //FirestoreのFriend犬のドキュメントID
    var friendImgString: String = "" //写真
    var friendNameString: String = "" //名前
    var friendSexString: String = "" //性別"
    var friendDogTypeString: String = "" //犬種
    var friemdMemoString: String = "" //メモ
    var friendInputDateString = "" //入力日時
    
   init(friendDogID:String,friendImgString:String,friendNameString:String,friendSexString:String,friendDogTypeString:String,friendMemoString:String,friendInputDateString:String){
       self.friendDogID = friendDogID
       self.friendImgString = friendImgString
       self.friendNameString = friendNameString
       self.friendSexString = friendSexString
       self.friendDogTypeString = friendDogTypeString
       self.friemdMemoString = friendMemoString
       self.friendInputDateString = friendInputDateString
   }
}
