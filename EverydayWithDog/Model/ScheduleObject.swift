//
//  SaveObject.swift
//  EverydayWithDog
//
//  Created by Masaki on 2/20/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ScheduleObject {
    var title: String = ""
    var startString: String = ""
    var endString: String = ""
    var contentsString: String = ""
    var scheduleDateString: String = ""
    
    func saveScheduleObject() {
        print(title)
        print(startString)
        print(endString)
        print(contentsString)
        print(scheduleDateString)
        
    } 
}
