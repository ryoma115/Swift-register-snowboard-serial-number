//
//  DeleteDBModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/18.
//

import UIKit
import Firebase
import FirebaseFirestore

class DeleteDBModel{
    let db = Firestore.firestore()
    
    func deleteDocument(documentID:String, completion: @escaping (Bool)-> ()){
        db.collection("snowboards").document(documentID).delete { error in
            if error != nil{
                print("Error removing document: \(error.debugDescription)")
                completion(true)
            }else{
                print("Document successfully removed!")
            }
            completion(false)
        }
    }
}
