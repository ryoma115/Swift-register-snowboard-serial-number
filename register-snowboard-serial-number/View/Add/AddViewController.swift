//
//  AddViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/02/02.
//

import UIKit
import FirebaseAuth

class AddViewController: UIViewController {

    let viewModel = AddViewModel()

//MARK: IBOutlet

    @IBOutlet private var boardImage: UIImageView!
    @IBOutlet private var nameTextField: UITextField! {
        didSet{
            nameTextField.delegate = self
        }
    }
    @IBOutlet private var boadBrandTextField: UITextField! {
        didSet{
            boadBrandTextField.delegate = self
        }
    }
    @IBOutlet private var SerialNumberTextField: UITextField! {
        didSet{
            SerialNumberTextField.delegate = self
        }
    }
    @IBOutlet private var warningLabel: UILabel!
    @IBOutlet private var tabBar: UITabBar! {
        didSet{
            tabBar.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.showCheckPermission()
        boardImage.image = UIImage(named: "no-image")
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func tapAddButton(_ sender: Any) {
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
                        let sendData = SendBoardModel(fullName: self.nameTextField.text!, userID: Auth.auth().currentUser!.uid, userEmail: (Auth.auth().currentUser?.email)!, boardBrand: self.boadBrandTextField.text!, boardSerialNumber: self.SerialNumberTextField.text!, boardImage: boardImageData!)
                        self.viewModel.sendDB(sendData: sendData) { error in
                            if error == false{
                                self.boardImage.image = UIImage(named:"no-image")
                                self.nameTextField.text = ""
                                self.boadBrandTextField.text = ""
                                self.SerialNumberTextField.text = ""
                                let indicator = UIActivityIndicatorView()
                                indicator.center = self.view.center
                                indicator.style = .large
                                indicator.color = .black
                                self.view.addSubview(indicator)
                                self.view.bringSubviewToFront(indicator)
                                indicator.startAnimating()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    indicator.stopAnimating()
                                    self.viewModel.generaterSetUp(generaterType: .success)
                                    let storyboard: UIStoryboard = UIStoryboard(name: "MyList", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier: "MyListViewController")
                                    self.navigationController?.pushViewController(viewController, animated: false)
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
    @IBAction func tapImage(_ sender: Any) {
        showCameraAlert()
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
        present(alertController, animated: true, completion: nil)
    }
    func startingUpCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .camera
            imagePickerView.isEditing = true
            imagePickerView.delegate = self
            present(imagePickerView, animated: true)
        }
    }
    func startingUpAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.isEditing = true
            imagePickerView.delegate = self
            present(imagePickerView, animated: true)
        }
    }
}

extension AddViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as! UIImage
        boardImage.image = selectedImage
        self.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        boadBrandTextField.resignFirstResponder()
        SerialNumberTextField.resignFirstResponder()
        return true
    }
}
extension AddViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag{
        case 1:
            let storyboard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
            self.navigationController?.pushViewController(viewController, animated: false)
        case 2:
            let storyboard: UIStoryboard = UIStoryboard(name: "MyList", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyListViewController")
            self.navigationController?.pushViewController(viewController, animated: false)
        case 3:
            let storyboard: UIStoryboard = UIStoryboard(name: "Add", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AddViewController")
            self.navigationController?.pushViewController(viewController, animated: false)
        case 4:
            let storyboard: UIStoryboard = UIStoryboard(name: "Setting", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
            self.navigationController?.pushViewController(viewController, animated: false)
        default : return
        }
    }
}
