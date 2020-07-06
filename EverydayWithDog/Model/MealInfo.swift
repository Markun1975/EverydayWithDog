//
//  MealInfo.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/16/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import UIKit
class MealInfo {

var mealString = "" //食べた量
var mealTimeString = "" //食べた時間
var mealContentString:String = "" //食べた内容
var mealDocumentId:String = "" //ドキュメントID

    init(mealString:String,mealTimeString:String,mealContentString:String,mealDocumentId:String){
    
    self.mealString = mealString
    self.mealTimeString = mealTimeString
    self.mealContentString = mealContentString
    self.mealDocumentId = mealDocumentId
 }
}
