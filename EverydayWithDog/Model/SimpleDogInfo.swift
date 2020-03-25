//
//  DogsInfo.swift
//  EverydayWithDog
//
//  Created by Masaki on 1/23/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import UIKit

class SimpleDogInfo {
    
    var nameString:String = "" //ワンちゃんの名前"
    var inputDateString = "" //入力日時
    var dogID = "" //Firestoreの犬のドキュメントID
    
    init(nameString:String,inputDateString:String,dogID:String){
        
        self.nameString = nameString
        self.inputDateString = inputDateString
        self.dogID = dogID
    }
}

