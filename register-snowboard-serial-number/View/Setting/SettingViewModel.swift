//
//  SettingViewModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/31.
//

import UIKit
import FirebaseFirestore

final class SettingViewModel {
    
    let db = Firestore.firestore()
    var addressData = [AddressData]()
    
    func loadContactAddress(searchWord:String,completion: @escaping (Bool) -> ()){
        self.addressData = []
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
    
    func sendAddress(_ acceptData:AcceptAdressData){
        self.db.collection("contactAddresses").document().setData(["userEmail":acceptData.userEmail as Any,"contactAddress":acceptData.contactAddress as Any])
    }
    
    func updateAddress(documentID:String,chageAddress:String){
        db.collection("contactAddresses").document(documentID).updateData(["contactAddress":chageAddress])
    }
}
