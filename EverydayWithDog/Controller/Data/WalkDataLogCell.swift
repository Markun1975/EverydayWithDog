//
//  WalkDataLogCell.swift
//  EverydayWithDog
//
//  Created by Masaki on 9/3/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit

class WalkDataLogCell: UITableViewCell {
    
    @IBOutlet var walkDataLogCell: UIView!
    
    @IBOutlet var walkDayLabel: UILabel!
    
    @IBOutlet var content1Label: UILabel!
    
    @IBOutlet var content2Label: UILabel!
    
    @IBOutlet var content3Label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String){
    }
    
}
