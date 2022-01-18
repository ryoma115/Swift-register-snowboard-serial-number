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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .systemGray6
        loadDB.loadUserData(searchWord: (Auth.auth().currentUser?.email)!, searchType: "userEmail") { (error) in
            if error == false {
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDB.dataSets.count
    }
}
