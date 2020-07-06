//
//  WaterInfo.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/16/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import UIKit
class WaterInfo {

var waterString = "" //飲んだ量
var waterTimeString = "" //飲んだ時間
var waterPlaceString:String = "" //飲んだ場所
var waterDocumentId:String = "" //ドキュメントID

init(waterString:String,waterTimeString:String,waterPlaceString:String,waterDocumentId:String){
    
    self.waterString = waterString
    self.waterTimeString = waterTimeString
    self.waterPlaceString = waterPlaceString
    self.waterDocumentId = waterDocumentId
 }
}
