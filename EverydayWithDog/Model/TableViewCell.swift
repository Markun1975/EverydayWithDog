//
//  TableViewCell.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/9/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit
//カレンダーの予定表示Cellの設定
class TableViewCell: UITableViewCell {
    
    @IBOutlet var ScheduleContentVCell: UIView!
    
    @IBOutlet var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 27
        cellView.layer.borderWidth = 0.05
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String){
    }
}
