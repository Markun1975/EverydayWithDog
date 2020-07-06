//
//  deleteCollection.swift
//  EverydayWithDog
//
//  Created by Masaki on 5/16/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

let uid = Auth.auth().currentUser?.uid

let collection = ""

class deleteCollection{
//    let documentID = ""
//    
////    let uid = Auth.auth().currentUser?.uid
//    
//    var fetchDogInfo =  Firestore.firestore().collection("user").document(uid!).collection(collection)
// 
//    func delete(collection: CollectionReference, batchSize: Int = 100) {
//      collection.limit(to: batchSize).getDocuments { (docset, error) in
//    
//      
//      let docset = docset
//
//      let batch = collection.firestore.batch()
//      docset?.documents.forEach { batch.deleteDocument($0.reference) }
//
//      batch.commit {_ in
//        self.delete(collection: collection, batchSize: batchSize)
//      }
//    }
//    }
    
}
