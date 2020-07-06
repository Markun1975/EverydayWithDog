//
//  WalkDataViewCellTableViewCell.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/14/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit


class WalkDataViewCellTableViewCell: UITableViewCell {

    @IBOutlet var WalkDataCell: UIView!
    
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String){
    }
}
