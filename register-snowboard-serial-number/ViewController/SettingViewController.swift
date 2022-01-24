//
//  SettingViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SettingViewController: UIViewController {
    
    let db = Firestore.firestore()
    let loadDB = LoadDBModel()
    
    @IBOutlet weak var contactAddressTextField: UITextField!
    @IBOutlet weak var warnningLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactAddressTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        warnningLabel.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func settingButton(_ sender: Any) {
        if contactAddressTextField.text == ""{
            warnningLabel.text = "連絡先が入力されていません"
        }else{
            let sendDB = SendDBModel(userEmail: (Auth.auth().currentUser?.email)!, contactAddress: contactAddressTextField.text!)
            sendDB.sendAddress()
            contactAddressTextField.text = ""
            warnningLabel.isHidden = false
            warnningLabel.text = "登録が完了しました！"
        }
    }
    
    @IBAction func displayButton(_ sender: Any) {
        loadDB.loadContactAddress(searchWord: (Auth.auth().currentUser?.email)!) { result in
            self.warnningLabel.isHidden = true
            self.currentAddressLabel.text = result
        }
        
    }
}
extension SettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contactAddressTextField.resignFirstResponder()
        return true
    }
}

