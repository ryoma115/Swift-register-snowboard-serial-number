//
//  SearchViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit
import FirebaseAuth

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningLabel: UILabel!
    let loadDB = LoadDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        searchText.delegate = self
        searchText.placeholder = "シリアルナンバーを入力してください"
        tableView.backgroundColor = .systemGray5
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchText.endEditing(true)
        loadDB.dataSets = []
        warningLabel.text = ""
        tableView.reloadData()
        if searchText.text?.isEmpty == true{
            warningLabel.text = "シリアルナンバーが入力されていません！"
        }else{
            loadDB.loadUserData(searchWord: searchText.text!, searchType: "boardSerialNumber") { error in
                if error == false{
                    if self.loadDB.dataSets.count == 0{
                        self.warningLabel.text = "シリアルナンバーが見つかりませんでした"
                    }else{
                        self.warningLabel.text = "検索結果: \(self.loadDB.dataSets.count)件見つかりました"
                        self.tableView.reloadData()
                    }
                }
            }
        }
        searchText.text = ""
    }
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyListTableViewCell
        cell.lostSwitch.isHidden = true
        cell.lostLabel.isHidden = true
        cell.fullName.text = loadDB.dataSets[indexPath.row].fullName
        cell.userID.text = loadDB.dataSets[indexPath.row].userID
        cell.boardSerialNumber.text = loadDB.dataSets[indexPath.row].boardSerialNumber
        cell.boardBrand.text = loadDB.dataSets[indexPath.row].boardBrand
        cell.dateID.text = String(loadDB.dataSets[indexPath.row].postDate)
        cell.boardImage.sd_setImage(with: URL(string: loadDB.dataSets[indexPath.row].boardImageUrl), completed: nil)
        cell.setUp()
        cell.selectionStyle = .none
        
        if loadDB.dataSets[indexPath.row].lost{
            let addButton = UIButton()
            addButton.setTitle("発見", for: .normal)
            addButton.setTitleColor(.white, for: .normal)
            addButton.backgroundColor = .red
            addButton.layer.cornerRadius = 8
            addButton.tag = indexPath.row
            addButton.addTarget(self, action: #selector(discoverButton), for: UIControl.Event.touchUpInside)
            addButton.frame = CGRect(x:20, y:20, width:40, height:40)
            cell.contentView.addSubview(addButton)
        }
        return cell
    }
    
    @objc func discoverButton(_ sender: UIButton) {
        self.loadDB.loadContactAddress(searchWord: (Auth.auth().currentUser?.email)!) { result in
            let alert = UIAlertController(title:  "注意", message: "こちらのアカウントまで報告お願いします！\n\(self.loadDB.addressData[0].contactAddress)", preferredStyle: .actionSheet)
            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let copyAlert = UIAlertAction(title: "コピー", style: .default) { (action) in
                UIPasteboard.general.string = self.loadDB.addressData[0].contactAddress
            }
            alert.addAction(cancelAlert)
            alert.addAction(copyAlert)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDB.dataSets.count
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.resignFirstResponder()
        searchButton((Any).self)
        return true
    }
}


