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
                print(self.loadDB.dataSets.count)
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
        
        let addButton = UIButton()
        addButton.setTitle("X", for: .normal)
        addButton.setTitleColor(.gray, for: .normal)
        addButton.tag = indexPath.row
        addButton.addTarget(self, action: #selector(buttonEvemt), for: UIControl.Event.touchUpInside)
        addButton.frame = CGRect(x:0, y:0, width:80, height:80)
        cell.contentView.addSubview(addButton)
        cell.selectionStyle = .none
        return cell
    }
    @objc func buttonEvemt(_ sender: UIButton) {
        deleteDB.deleteDocument(documentID: loadDB.dataSets[sender.tag].documentID) { error in
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDB.dataSets.count
    }
}
