//
//  MyListViewModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/29.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class MyListViewModel {
    
    var dataSets = [AcceptData]()
    let db = Firestore.firestore()
    
    func fetchData(searchWord:String, searchType:String,completion: @escaping (Bool)-> ()) {
        dataSets = []
        db.collection("snowboards").whereField(searchType, isEqualTo: searchWord).getDocuments { querySnapshot, error in
            if error != nil{
                print(error.debugDescription)
                completion(true)
                return
            }
            for document in querySnapshot!.documents{
                let data = document.data()
                let documentID = String(document.documentID)
                let fullName = data["fullName"] as! String
                let userID = data["userID"] as! String
                let userEmail = data["userEmail"] as! String
                let boardBrand = data["boardBrand"] as! String
                let boardSerialNumber = data["boardSerialNumber"] as! String
                let boardImageUrl = data["boardImageUrl"] as! String
                let postDate = data["postDate"] as! Double
                let lost = data["lost"] as! Bool
                let getData = AcceptData(documentID: documentID, fullName: fullName,userID: userID, userEmail: userEmail, boardBrand: boardBrand, boardSerialNumber: boardSerialNumber, boardImageUrl: boardImageUrl, postDate: postDate, lost: lost)
                self.dataSets.append(getData)
            }
            completion(false)
        }
    }
    
    func deleteDocument(documentID:String, completion: @escaping (Bool)-> ()) {
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
    
    func changeTrue(documentID:String) {
        db.collection("snowboards").document(documentID).updateData(["lost":true])
    }
    
    func changeFalse(documentID:String) {
        db.collection("snowboards").document(documentID).updateData(["lost":false])
    }
}
