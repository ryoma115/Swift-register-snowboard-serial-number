//
//  UpdateDBModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class UpdateDBModel{
    let db = Firestore.firestore()
    
    func changeTrue(documentID:String){
        db.collection("snowboards").document(documentID).updateData(["lost":true])
    }
    func changeFalse(documentID:String){
        db.collection("snowboards").document(documentID).updateData(["lost":false])
    }
    func ContactAddress(documentID:String,chageAddress:String){
        db.collection("contactAddresses").document(documentID).updateData(["contactAddress":chageAddress])
    }
}
