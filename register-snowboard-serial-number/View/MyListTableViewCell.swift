//
//  MyListTableViewCell.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/14.
//

import UIKit

class MyListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var boardBrand: UILabel!
    @IBOutlet weak var boardSerialNumber: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var dateID: UILabel!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    @IBAction func lostSwitch(_ sender: Any) {
    }
    
    func setUp(){
        self.backgroundColor = .systemGray6
        
        self.shadowLayer.layer.cornerRadius = 10
        self.shadowLayer.layer.shadowOffset = CGSize(width: 5.0, height: 3.0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.6
        self.shadowLayer.layer.shadowRadius = 4
    }
}
