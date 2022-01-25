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
    var doucmentsNumber = [String]()
    var dataSets = [AcceptData]()
    var addressData = [AddressData]()
    
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
    func loadContactAddress(searchWord:String,completion: @escaping (Bool) -> ()){
        db.collection("contactAddresses").whereField("userEmail", isEqualTo:searchWord).getDocuments { querySnapshot, error in
            if error != nil{
                print(error.debugDescription)
            }
            if querySnapshot?.documents.count == 0{
                completion(false)
            }else{
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let documentID = document.documentID
                    let contactAddress  = data["contactAddress"] as! String
                    let userEmail = data["userEmail"] as! String
                    let getData = AddressData(documentID: documentID, userEmail: userEmail, contactAddress: contactAddress)
                    self.addressData.append(getData)
                    completion(true)
                }
            }
        }
    }
    func searchMatch(boardBrand:String,boardSerialNumber:String, completion: @escaping (Bool)-> ()){
        db.collection("snowboards").whereField("boardBrand", isEqualTo: boardBrand).whereField("boardSerialNumber", isEqualTo: boardSerialNumber).getDocuments { querySnapshot, error in
            if error != nil{
                print(error.debugDescription)
                completion(true)
                return
            }
            for document in querySnapshot!.documents{
                self.doucmentsNumber.append("document")
            }
            completion(false)
        }
    }
}

