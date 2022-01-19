//
//  MyListViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit
import FirebaseAuth
import SDWebImage

class MyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let loadDB = LoadDBModel()
    let deleteDB = DeleteDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemGray6
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loadDB.dataSets = []
        loadDB.loadUserData(searchWord: (Auth.auth().currentUser?.email)!, searchType: "userEmail") { (error) in
            if error == false {
                self.tableView.reloadData()
            }
        }
    }
}

extension MyListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyListTableViewCell
        cell.fullName.text = loadDB.dataSets[indexPath.row].fullName
        cell.dateID.text = String(loadDB.dataSets[indexPath.row].postDate)
        cell.userID.text = loadDB.dataSets[indexPath.row].userID
        cell.boardSerialNumber.text = loadDB.dataSets[indexPath.row].boardSerialNumber
        cell.boardBrand.text = loadDB.dataSets[indexPath.row].boardBrand
        cell.boardImage.sd_setImage(with: URL(string: loadDB.dataSets[indexPath.row].boardImageUrl), completed: nil)
        cell.setUp()
        cell.selectionStyle = .none
        
        let addButton = UIButton()
        addButton.setTitle("X", for: .normal)
        addButton.setTitleColor(.gray, for: .normal)
        addButton.tag = indexPath.row
        addButton.addTarget(self, action: #selector(buttonEvemt), for: UIControl.Event.touchUpInside)
        addButton.frame = CGRect(x:0, y:0, width:50, height:50)
        cell.contentView.addSubview(addButton)
        
        return cell
    }
    @objc func buttonEvemt(_ sender: UIButton) {
        let alert = UIAlertController(title: "注意", message: "本当に削除してもよろしいですか", preferredStyle: .actionSheet)
        let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAlert = UIAlertAction(title: "削除", style: .destructive) { (action) in
            self.deleteDB.deleteDocument(documentID: self.loadDB.dataSets[sender.tag].documentID) { error in
                if error{
                    print("fatail delete")
                }else{
                    print("launch load")
                    self.loadDB.dataSets = []
                    self.loadDB.loadUserData(searchWord: (Auth.auth().currentUser?.email)!, searchType: "userEmail") { (error) in
                        if error == false {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        alert.addAction(cancelAlert)
        alert.addAction(deleteAlert)
        present(alert, animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDB.dataSets.count
    }
}
