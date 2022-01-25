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
    @IBOutlet weak var lostSwitch: UISwitch!
    @IBOutlet weak var lostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUp(){
        self.backgroundColor = .systemGray5
        
        self.shadowLayer.layer.cornerRadius = 10
        self.shadowLayer.layer.shadowOffset = CGSize(width: 5.0, height: 3.0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.6
        self.shadowLayer.layer.shadowRadius = 4
        
        self.shadowLayer.layer.borderWidth = 0.5
        self.shadowLayer.layer.borderColor = UIColor(red: 32/255, green: 206/255, blue: 210/255, alpha: 1).cgColor
    }
}
