//
//  SendDBModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/12.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class SendDBModel{
    
    var fullName = String()
    var userID = String()
    var userEmail = String()
    var boardBrand = String()
    var boardSerialNumber = String()
    var boardImage = Data()
    let db = Firestore.firestore()

    init(fullName:String,userID:String,userEmail:String,boardBrand:String,boardSerialNumber:String,boaedImage:Data) {
        self.fullName = fullName
        self.userID = userID
        self.userEmail = userEmail
        self.boardBrand = boardBrand
        self.boardSerialNumber = boardSerialNumber
        self.boardImage = boaedImage
    }
    
    
    func sendDB(completion: @escaping (Bool)-> ()){
        let storage = Storage.storage()
        let storageUrl = storage.reference().child("board_name")
        let boardUrl = storageUrl.child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        boardUrl.putData(boardImage, metadata: nil) { metadata, error in
            if error != nil{
                print("SendDBModel putData error")
                completion(true)
            }
            
            boardUrl.downloadURL { [self] url, error in
                if error != nil{
                    print("SendDBModel downloadURL error")
                }
                self.db.collection("snowboards").document().setData(["fullName":fullName,"userID":self.userID as Any,"userEmail":self.userEmail as Any,"boardBrand":self.boardBrand as Any,"boardSerialNumber":self.boardSerialNumber as Any,"boardImageUrl":url?.absoluteString as Any,"postDate":Date().timeIntervalSince1970 as Any])
            }
        }
        completion(false)
    }
}
