//
//  TabBarViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        
        UITabBar.appearance().tintColor = UIColor(red: 32/255, green: 206/255, blue: 210/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
