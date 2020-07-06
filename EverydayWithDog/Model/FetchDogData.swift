//
//  FetchDogData.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/26/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class FetchDogData {
    let uid = Auth.auth().currentUser?.uid
    
    
    var dogName:String?
    var dogId:String?
     
     func fetchFirstDogId(){
//        let dogDataVC = DogDataViewController1()
        print("fetchFirstDogId")
        if dogId == nil {
                //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
                                    let db =  Firestore.firestore().collection("user").document(uid!).collection("dogList").limit(to: 1)
                                    db.getDocuments() { snapShot, err in
                                    guard let documents = snapShot?.documents else {
                                    print("snapShotがerrですよ！")
                                    return
                                   }
                                    for snap in documents {
                                    if let postData = snap.data() as? [String: Any]{
                                    let firstDogId = snap.documentID
                                        print(firstDogId,"TOP画面　初期のDOG ID")
                                        UserDefaults.standard.set(firstDogId, forKey: "dogFirstId")
                                        self.dogId = firstDogId
                                    let firstDogName = postData["dogName"] as? String
                                        print(firstDogName!,"TOP画面　初期のDOG NAME")
                                        UserDefaults.standard.set(firstDogName, forKey: "dogFirstName")
//                                        dogDataVC.dogNamelabel.text = firstDogName
                               }
                              }
                             }
            
            
        } else {
        print(dogName!,"だよ！")
        }
    }
    
}
