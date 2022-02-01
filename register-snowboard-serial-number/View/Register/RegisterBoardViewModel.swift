//
//  RegisterBoardViewModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/31.
//

import UIKit
import Photos
import FirebaseFirestore

final class RegisterBoardViewModel {
    
    var documentMatches = [String]()
    let db = Firestore.firestore()
    let registerView = RegisterBoardViewController()
    
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
    func indicatorSetUp() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.center = RegisterBoardViewController().view.center
        indicator.style = .large
        indicator.color = .black
        
        return indicator
    }
    func generaterSetUp(generaterType:UINotificationFeedbackGenerator.FeedbackType) {
        let generater = UINotificationFeedbackGenerator()
        generater.notificationOccurred(generaterType)
    }
    func showCameraAlert(){
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        let addCameraAction = UIAlertAction(title: "カメラ", style: .default) { result in
            self.startingUpCamera()
        }
        let addAlbumAction = UIAlertAction(title: "アルバム", style: .default) { result in
            self.startingUpAlbum()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(addCameraAction)
        alertController.addAction(addAlbumAction)
        alertController.addAction(cancelAction)
        registerView.present(alertController, animated: true, completion: nil)
    }
    func startingUpCamera(){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerView = UIImagePickerController()
                imagePickerView.sourceType = .camera
                imagePickerView.isEditing = true
                imagePickerView.delegate = registerView
                registerView.present(imagePickerView, animated: true)
            }
        }
        func startingUpAlbum(){
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePickerView = UIImagePickerController()
                imagePickerView.sourceType = .photoLibrary
                imagePickerView.isEditing = true
                imagePickerView.delegate = registerView
                registerView.present(imagePickerView, animated: true)
            }
        }
}
