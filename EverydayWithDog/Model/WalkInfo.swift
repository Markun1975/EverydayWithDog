//
//  WalkInfo.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/10/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation

class WalkInfo{
    var dayString:String = "" //歩いた日付とスタート時間
    var walkTimeString:String = "" //歩いた時間(◯h,◯m)
    var walkPlaceString:String = "" //散歩をした場所
    var distanceString:String = "" //散歩をした距離
    var walkDocumentId:String = "" //ドキュメントID
    
    init(dayString:String,walkTimeString:String,walkPlaceString:String,distanceString:String,walkDocumentId:String){
        
        self.dayString = dayString
        self.walkTimeString = walkTimeString
        self.walkPlaceString = walkPlaceString
        self.distanceString = distanceString
        self.walkDocumentId = walkDocumentId
    }
}
