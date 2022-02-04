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
    
// MARK: IBOutlet
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
            tableView.backgroundColor = .systemGray5
        }
    }
    @IBOutlet private var tabBar: UITabBar! {
        didSet{
            tabBar.delegate = self
        }
    }
    
    private let viewModel = MyListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.fetchData(searchWord: (Auth.auth().currentUser?.email)!, searchType: "userEmail") { error in
            if error == false {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: UITableViewDelegate,UITableViewDataSource
extension MyListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyListTableViewCell
        cell.delegate = self
        cell.deleteButton.tag = indexPath.row
        let acceptData = viewModel.dataSets[indexPath.row]
        cell.setUp(acceptData: acceptData)
        
        cell.lostSwitch.isOn = viewModel.dataSets[indexPath.row].lost
        cell.lostSwitch.tag = indexPath.row
        cell.lostSwitch.addTarget(self, action: #selector(changeSwitch(_:)), for: UIControl.Event.valueChanged)
        
        return cell
    }
    @objc func changeSwitch(_ sender: UISwitch) {
        if sender.isOn{
            viewModel.changeTrue(documentID: viewModel.dataSets[sender.tag].documentID)
        }else{
            viewModel.changeFalse(documentID: viewModel.dataSets[sender.tag].documentID)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSets.count
    }
}

//MARK: MyListTableViewCellDelegate
extension MyListViewController: MyListTableViewCellDelegate {
    func didTapButton(indexPathNumber: Int) {
        let alert = UIAlertController(title: "注意", message: "本当に削除してもよろしいですか?\n(復元ができなくなります)", preferredStyle: .actionSheet)
        let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
        }
        let deleteAlert = UIAlertAction(title: "削除", style: .destructive) { (action) in
            self.viewModel.deleteDocument(documentID: self.viewModel.dataSets[indexPathNumber].documentID) { error in
                if error{
                    print("fatail delete")
                }else{
                    print("launch load")
                    self.viewModel.dataSets = []
                    self.viewModel.fetchData(searchWord: (Auth.auth().currentUser?.email)!, searchType: "userEmail") { error in
                        if error == false {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        alert.addAction(cancelAlert)
        alert.addAction(deleteAlert)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: UITabBarDelegate
extension MyListViewController: UITabBarDelegate {
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
