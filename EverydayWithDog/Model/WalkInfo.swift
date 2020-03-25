//
//  WalkInfo.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/10/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation

class WalkInfo{
    var dayString:String = "" //歩いた日付
//    var walkTimeString:String = "" //歩いた時間(◯h,◯m)
    var walkEndTimeString = "" //歩き終わった時間
    var walkPlaceString:String = "" //散歩をした場所
    var distanceString:String = "" //散歩をした距離
    
    init(dayString:String,endTimeString:String,walkPlaceString:String,distanceString:String){
        
        self.dayString = dayString
        self.walkEndTimeString = endTimeString
        self.walkPlaceString = walkPlaceString
        self.distanceString = distanceString
    }
}
