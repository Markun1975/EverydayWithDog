//
//  GetFirstDogID.swift
//  EverydayWithDog
//
//  Created by Masaki on 3/17/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//
//
//import Foundation
//import Firebase
//import FirebaseDatabase
//import FirebaseStorage
//import FirebaseFirestore
//
//class GetFirstDogID{
//    
//    var dogID = String()
//    
//    let uid = Auth.auth().currentUser?.uid
//    
//    func fetchFirstDogID(){
//        
////        if dogID != nil {
//////                      dogID = UserDefaults.standard.object(forKey: "dogID") as! String
////                       print("初期でID入ってる！",dogID)
////                   } else {
//            //初期のDogIDを設定(このViewが開いたときにDogIDがnilにならないように)
//             let fetchDogInfo =  Firestore.firestore().collection("user").document(uid!).collection("dogList").limit(to: 1)
//             fetchDogInfo.getDocuments(){ snapShot, err in
//                       
//                               guard let documents = snapShot?.documents else {
//                                           print("snapShotがerrですよ！")
//                                           return
//                                   }
//                                           for snap in documents {
//                                               if let postData = snap.data() as? [String: Any]{
//                                                   self.dogID = snap.documentID
//                                                   print(self.dogID,"初期のMealData用のID取得したよ！")
//                               }
//                           }
//                       }
//                   }
//    }
