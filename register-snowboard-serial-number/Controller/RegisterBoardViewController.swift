//
//  RegisterBoardViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit
import FirebaseAuth

class RegisterBoardViewController: UIViewController {
    
    let photoCheckModel = PhotoCheckModel()
    
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var boadBrandTextField: UITextField!
    @IBOutlet weak var SerialNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardImage.image = UIImage(named: "no-image")
        photoCheckModel.showCheckPermission()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    @IBAction func tapImageView(_ sender: Any) {
        showAlert()
    }
    @IBAction func tapRegisterButton(_ sender: Any) {
        let boardImageData = (boardImage.image?.jpegData(compressionQuality: 0.25))
        let sendDBModel = SendDBModel(userID:Auth.auth().currentUser!.uid, userEmail: (Auth.auth().currentUser?.email)!, boardBrand:boadBrandTextField.text!, boardSerialNumber: SerialNumberTextField.text!, boaedImage:boardImageData!)
        sendDBModel.sendDB()
        boardImage.image = UIImage(named:"no-image")
        boadBrandTextField.text = ""
        SerialNumberTextField.text = ""
        self.navigationController?.popViewController(animated: true)
    
    }
    func showAlert(){
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
        self.present(alertController, animated: true, completion: nil)
    }
    func startingUpCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .camera
            imagePickerView.isEditing = true
            imagePickerView.delegate = self
            self.present(imagePickerView, animated: true)
        }
    }
    func startingUpAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.isEditing = true
            imagePickerView.delegate = self
            self.present(imagePickerView, animated: true)
        }
    }
}

extension RegisterBoardViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as! UIImage
        boardImage.image = selectedImage
        self.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
}
