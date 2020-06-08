//
//  deleteAlert.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/17/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation

c
let mealDataAlert: UIAlertController =
               UIAlertController(title: "削除しますか？", message: "この履歴を削除しますか？", preferredStyle: UIAlertController.Style.alert)
    
    let deleteCanceAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) -> Void in
        mealDataAlert.dismiss(animated: true, completion: nil)
    print("キャンセル")
    })
    
    let deleteAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) -> Void in
    print("削除できた!")
    })
    
    mealDataAlert.addAction(deleteCanceAction)
    mealDataAlert.addAction(deleteAction)
    present(mealDataAlert, animated: true, completion: nil)
}
