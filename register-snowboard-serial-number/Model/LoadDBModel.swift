//
//  LoadDBModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/13.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoadDBModel{
    
    let db = Firestore.firestore()
    var dataSets = [AcceptData]()
    
    func loadUserData(searchWord:String, searchType:String, completion: @escaping (Bool)-> ()){
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
    func loadContactAddress(searchWord:String,completion: @escaping (String) -> ()){
        db.collection("contactAddresses").whereField("userEmail", isEqualTo:searchWord).getDocuments { querySnapshot, error in
            if error != nil{
                print(error.debugDescription)
                completion("読み込みに失敗しました")
            }
            if querySnapshot?.documents.count == 0{
                completion("登録されていません")
            }else{
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let contactAddress  = data["contactAddress"] as! String
                    completion(contactAddress)
                }
            }
        }
    }
}

