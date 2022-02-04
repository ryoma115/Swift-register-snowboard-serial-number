//
//  AddViewModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/02/02.
//

import UIKit
import Photos
import FirebaseFirestore
import FirebaseStorage

final class AddViewModel {
    
    var documentMatches = [String]()
    let db = Firestore.firestore()
    
    func showCheckPermission(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized:
                print("Camera usage permission status: allow")
            case .denied:
                print("Camera usage permission status: reject")
            case .notDetermined:
                print("Camera usage permission status: notDetermined")
            case .restricted:
                print("Camera usage permission status: restricted")
            case .limited:
                print("Camera usage permission status: limited")
            @unknown default: break
            }
        }
    }
    func searchMatch(boardBrand:String,boardSerialNumber:String, completion: @escaping (Bool)-> ()){
        documentMatches = []
        db.collection("snowboards").whereField("boardBrand", isEqualTo: boardBrand).whereField("boardSerialNumber", isEqualTo: boardSerialNumber).getDocuments { querySnapshot, error in
            if error != nil{
                print(error.debugDescription)
                completion(true)
                return
            }
            for document in querySnapshot!.documents{
                self.documentMatches.append("matche")
            }
            completion(false)
        }
    }
    func generaterSetUp(generaterType:UINotificationFeedbackGenerator.FeedbackType) {
        let generater = UINotificationFeedbackGenerator()
        generater.notificationOccurred(generaterType)
    }
    func sendDB(sendData:SendBoardModel,completion: @escaping (Bool)-> ()){
        let storage = Storage.storage()
        let storageUrl = storage.reference().child("board_name")
        let boardUrl = storageUrl.child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        boardUrl.putData(sendData.boardImage, metadata: nil) { metadata, error in
            if error != nil{
                print("SendDBModel putData error")
                completion(true)
            }
            
            boardUrl.downloadURL { [self] url, error in
                if error != nil{
                    print("SendDBModel downloadURL error")
                }
                self.db.collection("snowboards").document().setData(["fullName":sendData.fullName,"userID":sendData.userID,"userEmail":sendData.userEmail,"boardBrand":sendData.boardBrand,"boardSerialNumber":sendData.boardSerialNumber,"boardImageUrl":url?.absoluteString as Any,"postDate":Date().timeIntervalSince1970,"lost": false])
            }
        }
        completion(false)
    }
}


