//
//  SearchViewModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/28.
//

import UIKit
import Firebase
import FirebaseFirestore

final class SearchViewModel {
    
    let db = Firestore.firestore()
    var doucmentsNumber = [String]()
    var dataSets = [AcceptData]()
    var addressData = [AddressData]()
    
    enum response {
        case loadError
        case notFound
        case Found
    }
        
    func searchData(searchWord:String,completion: @escaping (response)-> ()) {
        dataSets = []
        loadUserData(searchWord: searchWord, searchType: "boardSerialNumber") { error in
            if error{
                completion(.loadError)
                return
            }
            if self.dataSets.count == 0{
                completion(.notFound)
            } else {
                completion(.Found)
            }
        }
    }
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
    func loadContactAddress(searchWord:String,completion: @escaping (response) -> ()){
        db.collection("contactAddresses").whereField("userEmail", isEqualTo:searchWord).getDocuments { querySnapshot, error in
            if error != nil{
                print(error.debugDescription)
                completion(.loadError)
            }
            if querySnapshot?.documents.count == 0{
                completion(.notFound)
            }else{
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let documentID = document.documentID
                    let contactAddress  = data["contactAddress"] as! String
                    let userEmail = data["userEmail"] as! String
                    let getData = AddressData(documentID: documentID, userEmail: userEmail, contactAddress: contactAddress)
                    self.addressData.append(getData)
                    completion(.Found)
                }
            }
        }
    }
}
