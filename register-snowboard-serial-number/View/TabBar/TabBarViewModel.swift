//
//  TabBarViewModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/28.
//

import UIKit

final class TabBarViewModel {
    func tabBarSetUp(){
        UITabBar.appearance().tintColor = UIColor(red: 32/255, green: 206/255, blue: 210/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
    }
}
