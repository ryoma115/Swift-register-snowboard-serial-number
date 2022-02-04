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
    
// MARK: IBOutlet
    @IBOutlet private var contactAddressTextField: UITextField! {
        didSet{
            contactAddressTextField.delegate = self
        }
    }
    @IBOutlet private var guideLabel: UILabel! {
        didSet{
            guideLabel.text = "現在の連絡先"
        }
    }
    @IBOutlet private var warningLabel: UILabel! {
        didSet{
            warningLabel.text = "(反映に時間がかかる場合があります)"
        }
    }
    @IBOutlet private var currentAddressLabel: UILabel!
    @IBOutlet private var restrictLabel: UILabel! {
        didSet{
            restrictLabel.text = "*こちらはボードの紛失ボタンがONの状態で、\n発見ボタンが押された時のみ使用されます。\n(登録することを推奨します)"
        }
    }
    @IBOutlet private var settingButton: UIButton! {
        didSet{
            settingButton.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private var tabBar: UITabBar!{
        didSet{
            tabBar.delegate = self
        }
    }
    
    private let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restrictLabel.text = ""
        viewModel.loadContactAddress(searchWord: (Auth.auth().currentUser?.email)!)
        { result in
            if self.viewModel.addressData.count == 0{
                self.currentAddressLabel.text = "現在、登録されていません"
            }else{
                self.currentAddressLabel.text = self.viewModel.addressData[0].contactAddress
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: @IBAction
    @IBAction private func settingButton(_ sender: Any) {
        if contactAddressTextField.text == ""{
            restrictLabel.text = "連絡先が入力されていません"
        }else{
            viewModel.loadContactAddress(searchWord: (Auth.auth().currentUser?.email)!) {result in
                if result == false{
                    let getData = AcceptAdressData(contactAddress: self.contactAddressTextField.text!, userEmail:(Auth.auth().currentUser?.email)!)
                    self.viewModel.sendAddress(getData)
                    self.restrictLabel.text = "登録が完了しました！"
                } else {
                    self.viewModel.updateAddress(documentID: self.viewModel.addressData[0].documentID!, chageAddress: self.contactAddressTextField.text!)
                    self.restrictLabel.text = "変更が完了しました！"
                }
                self.currentAddressLabel.text = self.contactAddressTextField.text
                self.contactAddressTextField.text = ""
                self.restrictLabel.isHidden = false
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension SettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contactAddressTextField.resignFirstResponder()
        return true
    }
}

//MARK: UITabBarDelegate
extension SettingViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UITabBar.appearance().tintColor = UIColor(red: 32, green: 206, blue: 210, alpha: 1.0)
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
