//
//  SearchViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit

final class SearchViewController: UIViewController {
    
// MARK: IBOutlet
    
    @IBOutlet private weak var searchText: UITextField! {
        didSet {
            searchText.delegate = self
        }
    }
    @IBOutlet private weak var searchButton: UIButton! {
        didSet{
            searchButton.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var tabBar: UITabBar! {
        didSet{
            tabBar.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .systemGray5
            tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .systemGray5
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
// MARK: @IBAction
    
    @IBAction private func searchButton(_ sender: Any) {
        warningLabel.text = ""
        if searchText.text?.isEmpty == true{
            warningLabel.text = "シリアルナンバーが入力されていません！"
        }else{
            viewModel.searchData(searchWord: searchText.text!) { response in
                switch response {
                case .loadError:
                    self.warningLabel.text = "読み込みに失敗しました"
                case .notFound:
                    self.warningLabel.text = "シリアルナンバーが見つかりませんでした"
                case .Found:
                    self.warningLabel.text = "検索結果: \(self.viewModel.dataSets.count)件見つかりました"
                    self.tableView.reloadData()
                }
            }
        }
        searchText.text = ""
    }
}

// MARK: UITableViewDelegate,UITableViewDataSource

extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        let acceptData = viewModel.dataSets[indexPath.row]
        cell.foundButton.tag = indexPath.row
        cell.setUp(acceptData: acceptData)
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSets.count
    }
}

// MARK: UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.resignFirstResponder()
        searchButton((Any).self)
        return true
    }
}

// MARK: SearchTableViewCellDelegate

extension SearchViewController:SearchTableViewCellDelegate {
    
    func didTapButton(indexPathNumber: Int) {
        viewModel.loadContactAddress(searchWord: viewModel.dataSets[indexPathNumber].userEmail) { response in
            switch response {
            case .loadError:
                let alert = UIAlertController(title:  "注意", message: "読み込みに失敗しました。", preferredStyle: .actionSheet)
                let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel)
                alert.addAction(cancelAlert)
                self.present(alert, animated: true)
            case .notFound:
                let alert = UIAlertController(title:  "注意", message: "緊急連絡先の登録がありませんでした。", preferredStyle: .actionSheet)
                let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel)
                alert.addAction(cancelAlert)
                self.present(alert, animated: true)
            case .Found:
                let alert = UIAlertController(title:  "注意", message: "こちらのアカウントまで報告お願いします！\n\(self.viewModel.addressData[0].contactAddress)", preferredStyle: .actionSheet)
                let copyAlert = UIAlertAction(title: "コピー", style: .default) { (action) in
                    UIPasteboard.general.string = self.viewModel.addressData[0].contactAddress
                }
                alert.addAction(copyAlert)
                let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel)
                alert.addAction(cancelAlert)
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: UITabBarDelegate

extension SearchViewController: UITabBarDelegate {
    
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
