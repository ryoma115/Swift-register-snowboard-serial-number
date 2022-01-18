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
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    func setUp(){
        self.mainBackground.layer.cornerRadius = 10
        self.mainBackground.layer.masksToBounds = true
        self.backgroundColor = .systemGray6
        
        self.shadowLayer.layer.cornerRadius = 10
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowRadius = 3
        self.shadowLayer.layer.shadowOpacity = 0.3
        self.shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.shadowLayer.layer.shouldRasterize = true
        self.shadowLayer.layer.rasterizationScale = UIScreen.main.scale
    }
}
