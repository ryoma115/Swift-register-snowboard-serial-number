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
        view.backgroundColor = .systemGray6
        searchText.delegate = self
        searchText.placeholder = "シリアルナンバーを入力してください"
        tableView.backgroundColor = .systemGray6
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        cell.fullName.text = loadDB.dataSets[indexPath.row].fullName
        cell.userID.text = loadDB.dataSets[indexPath.row].userID
        cell.boardSerialNumber.text = loadDB.dataSets[indexPath.row].boardSerialNumber
        cell.boardBrand.text = loadDB.dataSets[indexPath.row].boardBrand
        cell.boardImage.sd_setImage(with: URL(string: loadDB.dataSets[indexPath.row].boardImageUrl), completed: nil)
        cell.setUp()
        cell.selectionStyle = .none
        return cell
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
        return true
    }
}


