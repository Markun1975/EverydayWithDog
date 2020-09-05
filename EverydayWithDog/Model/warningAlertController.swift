//
//  warningAlertController.swift
//  EverydayWithDog
//
//  Created by Masaki on 8/28/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit

class warningAlertController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
            warningAlertAction()
        }
        
         func warningAlertAction(){
            let warningAlert = UIAlertController(title: "日時を入力してください", message: "日時が入力されない場合、記録が残せません。", preferredStyle: UIAlertController.Style.alert)
            
                let checkOKAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                    warningAlert.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                    }

                    warningAlert.addAction(checkOKAction)
                    present(warningAlert, animated: true)
        }
    }

