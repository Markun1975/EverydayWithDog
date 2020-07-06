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
    
    @IBOutlet var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = cellView.bounds.height/21
        cellView.layer.borderWidth = 0.05
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowRadius = 1
        cellView.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String){
    }
}
