//
//  WalkDataViewCellTableViewCell.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/14/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit


class DataLogTableViewCell: UITableViewCell {

    @IBOutlet var dataLogCell: UIView!
    
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var content1Label: UILabel!
    
    @IBOutlet var content2Label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String){
    }
}
