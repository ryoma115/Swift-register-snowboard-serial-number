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
    let loadDB = LoadDBModel()
    
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var boadBrandTextField: UITextField!
    @IBOutlet weak var SerialNumberTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardImage.image = UIImage(named: "no-image")
        photoCheckModel.showCheckPermission()
        boadBrandTextField.delegate = self
        SerialNumberTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func tapImageView(_ sender: Any) {
        showAlert()
    }
    @IBAction func tapRegisterButton(_ sender: Any) {
        warningLabel.text = ""
        let generater = UINotificationFeedbackGenerator()
        if nameTextField.text == "" || boadBrandTextField.text == "" || SerialNumberTextField.text == ""{
            warningLabel.text = "＊入力欄に誤りがあります"
            generater.notificationOccurred(.error)
        }else{
            loadDB.doucmentsNumber = []
            loadDB.searchMatch(boardBrand: boadBrandTextField.text!, boardSerialNumber: SerialNumberTextField.text!) { error in
                if error{
                    self.warningLabel.text = "読み込みに失敗しました"
                }else{
                    if self.loadDB.doucmentsNumber.count == 0{
                        let boardImageData = (self.boardImage.image?.jpegData(compressionQuality: 0.25))
                        let sendDBModel = SendDBModel(fullName:self.nameTextField.text!,userID:Auth.auth().currentUser!.uid, userEmail: (Auth.auth().currentUser?.email)!, boardBrand:self.boadBrandTextField.text!,boardSerialNumber: self.SerialNumberTextField.text!, boaedImage:boardImageData!)
                        sendDBModel.sendDB { error in
                            if error == false{
                                self.boardImage.image = UIImage(named:"no-image")
                                self.nameTextField.text = ""
                                self.boadBrandTextField.text = ""
                                self.SerialNumberTextField.text = ""
                                let indicatorView = UIActivityIndicatorView()
                                indicatorView.center = self.view.center
                                indicatorView.style = .large
                                indicatorView.color = .black
                                self.view.addSubview(indicatorView)
                                self.view.bringSubviewToFront(indicatorView)
                                indicatorView.startAnimating()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    indicatorView.stopAnimating()
                                    generater.notificationOccurred(.success)
                                    let nextStoryboard = UIStoryboard(name: "MyList",bundle: nil)
                                    guard let nextViewController = nextStoryboard.instantiateInitialViewController() as? MyListViewController else { return }
                                    self.navigationController?.pushViewController(nextViewController, animated: true)
                                }
                            }
                        }
                    } else {
                        self.warningLabel.text = "既にこの製品は登録されています"
                    }
                }
            }
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

extension RegisterBoardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        boadBrandTextField.resignFirstResponder()
        SerialNumberTextField.resignFirstResponder()
        return true
    }
}
