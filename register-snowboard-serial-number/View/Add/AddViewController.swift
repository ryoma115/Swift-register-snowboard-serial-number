//
//  AddViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/02/02.
//

import UIKit
import FirebaseAuth

final class AddViewController: UIViewController {

// MARK: IBOutlet
    
    @IBOutlet private weak var boardImage: UIImageView! {
        didSet{
            boardImage.image = UIImage(named: "no-image")
        }
    }
    @IBOutlet private weak var nameTextField: UITextField! {
        didSet{
            nameTextField.delegate = self
        }
    }
    @IBOutlet private weak var boardBrandTextField: UITextField! {
        didSet{
            boardBrandTextField.delegate = self
        }
    }
    @IBOutlet private weak var serialNumberTextField: UITextField! {
        didSet{
            serialNumberTextField.delegate = self
        }
    }
    @IBOutlet private weak var addButton: UIButton! {
        didSet{
            addButton.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var tabBar: UITabBar! {
        didSet{
            tabBar.delegate = self
        }
    }
    
    private let viewModel = AddViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.showCheckPermission()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
// MARK: @IBAction
    
    @IBAction private func tapImage(_ sender: Any) {
        showCameraAlert()
    }

    @IBAction private func tapAddButton(_ sender: Any) {
        let nameText = nameTextField.text
        let boardText = boardBrandTextField.text
        let serialNumberText = serialNumberTextField.text
        warningLabel.text = ""
        if nameText == nil || boardText == nil || serialNumberText == nil {
            warningLabel.text = "＊入力欄に誤りがあります"
            generaterSetUp(generaterType: .error)
        }else{
            viewModel.searchMatch(boardBrand: boardText ?? "", boardSerialNumber: serialNumberText ?? "") { error  in
                guard error != false else { self.warningLabel.text = "読み込みに失敗しました"; return }
                if self.viewModel.documentMatches.count == 0 {
                    guard let auth = Auth.auth().currentUser  else { return }
                    let boardImageData = (self.boardImage.image?.jpegData(compressionQuality: 0.25))
                    let sendData = SendBoardModel(
                        fullName: nameText,
                        userID: auth.uid,
                        userEmail: auth.email ?? "",
                        boardBrand: boardText,
                        boardSerialNumber: serialNumberText,
                        boardImage: boardImageData!
                    )
                    self.viewModel.sendDB(sendData: sendData) { error in
                        if error == false {
                            self.setUpClose()
                        }
                    }
                } else {
                    self.warningLabel.text = "既にこの製品は登録されています"
                }
            }
        }
    }
}

// MARK: UIImagePickerControllerDelegate,UINavigationControllerDelegate

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

// MARK: UITextFieldDelegate

extension AddViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        boardBrandTextField.resignFirstResponder()
        serialNumberTextField.resignFirstResponder()
        return true
    }
}

// MARK: UITabBarDelegate

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

extension AddViewController {
    
    private func setUpClose() {
        self.boardImage.image = UIImage(named:"no-image")
        self.nameTextField.text = ""
        self.boardBrandTextField.text = ""
        self.serialNumberTextField.text = ""
        let indicator = UIActivityIndicatorView()
        indicator.center = self.view.center
        indicator.style = .large
        indicator.color = .black
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            indicator.stopAnimating()
            self.generaterSetUp(generaterType: .success)
            let storyboard: UIStoryboard = UIStoryboard(name: "MyList", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyListViewController")
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    private func showCameraAlert(){
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
    
    private func startingUpCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .camera
            imagePickerView.isEditing = true
            imagePickerView.delegate = self
            present(imagePickerView, animated: true)
        }
    }
    
    private func startingUpAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.isEditing = true
            imagePickerView.delegate = self
            present(imagePickerView, animated: true)
        }
    }
    
    private func generaterSetUp(generaterType:UINotificationFeedbackGenerator.FeedbackType) {
        let generater = UINotificationFeedbackGenerator()
        generater.notificationOccurred(generaterType)
    }
}
