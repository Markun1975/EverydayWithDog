//
//  ScheduleContent.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/8/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation

class ScheduleContent {
    var scheduleTitleString: String = ""
    var scheduleStartTimeString: String = ""
    var scheduleEndTimeString: String = ""
    var scheduleContentString: String = ""
    
    init(titleString:String,startString:String,endString:String,contentString:String) {
        self.scheduleTitleString = titleString
        self.scheduleStartTimeString = startString
        self.scheduleEndTimeString = endString
        self.scheduleContentString = contentString
    }
}
