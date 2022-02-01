//
//  TabBarViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let viewModel = TabBarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        viewModel.tabBarSetUp()
    }
}
