//
//  RegisterBoardViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit
import FirebaseAuth

class RegisterBoardViewController: UIViewController {
    
    let viewModel = RegisterBoardViewModel()
    let loadDB = LoadDBModel()
    
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet{
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var boadBrandTextField: UITextField! {
        didSet{
            boadBrandTextField.delegate = self
        }
    }
    @IBOutlet weak var SerialNumberTextField: UITextField! {
        didSet{
            SerialNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardImage.image = UIImage(named: "no-image")
        viewModel.showCheckPermission()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func tapImageView(_ sender: Any) {
        viewModel.showCameraAlert()
    }
    @IBAction func tapRegisterButton(_ sender: Any) {
        warningLabel.text = ""
        if nameTextField.text == "" || boadBrandTextField.text == "" || SerialNumberTextField.text == ""{
            warningLabel.text = "＊入力欄に誤りがあります"
            viewModel.generaterSetUp(generaterType: .error)
        }else{
            viewModel.searchMatch(boardBrand: boadBrandTextField.text!, boardSerialNumber: SerialNumberTextField.text!) { error in
                if error{
                    self.warningLabel.text = "読み込みに失敗しました"
                }else{
                    if self.viewModel.documentMatches.count == 0{
                        let boardImageData = (self.boardImage.image?.jpegData(compressionQuality: 0.25))
                        let sendDBModel = SendDBModel(fullName:self.nameTextField.text!,userID:Auth.auth().currentUser!.uid, userEmail: (Auth.auth().currentUser?.email)!, boardBrand:self.boadBrandTextField.text!,boardSerialNumber: self.SerialNumberTextField.text!, boaedImage:boardImageData!)
                        sendDBModel.sendDB { error in
                            if error == false{
                                self.boardImage.image = UIImage(named:"no-image")
                                self.nameTextField.text = ""
                                self.boadBrandTextField.text = ""
                                self.SerialNumberTextField.text = ""
                                let indicatorView = self.viewModel.indicatorSetUp()
                                self.view.addSubview(indicatorView)
                                self.view.bringSubviewToFront(indicatorView)
                                indicatorView.startAnimating()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    indicatorView.stopAnimating()
                                    self.viewModel.generaterSetUp(generaterType: .success)
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
