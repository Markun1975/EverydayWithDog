//
//  ToiletInfo.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/5/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation

class ToiletInfo {
    
    var toiletTimeString:String = "" //トイレをした時間
    var toiletPlaceString:String = "" //トイレをした場所
    var toiletTypeString:String = "" //トイレの種類 大か小か
    var toiletDocumentId:String = "" //ドキュメントID
    
    init(toiletTimeString:String,toiletPlaceString:String,toiletDocumentId:String,toiletTypeString:String){
        
        self.toiletTimeString = toiletTimeString
        self.toiletPlaceString = toiletPlaceString
        self.toiletDocumentId = toiletDocumentId
        self.toiletTypeString = toiletTypeString
    }
}
