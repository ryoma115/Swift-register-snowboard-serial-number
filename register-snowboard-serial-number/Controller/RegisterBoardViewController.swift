//
//  RegisterBoardViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit

class RegisterBoardViewController: UIViewController {
    
    let photoCheckModel = PhotoCheckModel()
    
    @IBOutlet weak var boardImage: UIImageView!
    
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
            imagePickerView.delegate = self
            self.present(imagePickerView, animated: true)
        }
    }
    func startingUpAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .photoLibrary
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
