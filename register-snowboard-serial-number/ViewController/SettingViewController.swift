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
    let updateDB = UpdateDBModel()
    
    @IBOutlet weak var contactAddressTextField: UITextField!
    @IBOutlet weak var guideLabel: UILabel!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var restrictLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactAddressTextField.delegate = self
        guideLabel.text = "現在の連絡先"
        warningLabel.text = "反映に時間がかかる場合があります"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restrictLabel.isHidden = true
        loadDB.loadContactAddress(searchWord: (Auth.auth().currentUser?.email)!) { result in
            self.restrictLabel.isHidden = true
            if self.loadDB.addressData.count == 0{
                self.currentAddressLabel.text = "登録されていません"
            }else{
                self.currentAddressLabel.text = self.loadDB.addressData[0].contactAddress
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func settingButton(_ sender: Any) {
        if contactAddressTextField.text == ""{
            restrictLabel.text = "連絡先が入力されていません"
        }else{
            loadDB.loadContactAddress(searchWord: (Auth.auth().currentUser?.email)!) {result in
                if result == false{
                    let sendDB = SendDBModel(userEmail: (Auth.auth().currentUser?.email)!, contactAddress: self.contactAddressTextField.text!)
                    sendDB.sendAddress()
                    self.restrictLabel.text = "登録が完了しました！"
                } else {
                    self.updateDB.ContactAddress(documentID: self.loadDB.addressData[0].documentID, chageAddress: self.contactAddressTextField.text!)
                    self.restrictLabel.text = "変更が完了しました！"
                }
                self.contactAddressTextField.text = ""
                self.restrictLabel.isHidden = false
            }
        }
    }
}
extension SettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contactAddressTextField.resignFirstResponder()
        return true
    }
}

