//
//  MyListTableViewCell.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/14.
//

import UIKit

protocol MyListTableViewCellDelegate: AnyObject {
    func didTapButton(indexPathNumber:Int)
}

class MyListTableViewCell: UITableViewCell {
    
    var delegate:MyListTableViewCellDelegate?
    
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var boardBrand: UILabel!
    @IBOutlet weak var boardSerialNumber: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var dateID: UILabel!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var lostSwitch: UISwitch!
    @IBOutlet weak var lostLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var firstUpView: UIView!
    @IBOutlet weak var firstDownView: UIView!
    @IBOutlet weak var secondUpView: UIView!
    @IBOutlet weak var secondDownView: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setUp(acceptData:AcceptData){
        self.backgroundColor = .systemGray5
        
        fullName.text = acceptData.fullName
        dateID.text = String(acceptData.postDate)
        userID.text = acceptData.userID
        boardSerialNumber.text = acceptData.boardSerialNumber
        boardBrand.text = acceptData.boardBrand
        boardImage.sd_setImage(with: URL(string: acceptData.boardImageUrl), completed: nil)
        lostSwitch.isOn = acceptData.lost
        
        self.shadowLayer.layer.cornerRadius = 10
        self.shadowLayer.layer.shadowOffset = CGSize(width: 7.0, height: 5.0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.6
        self.shadowLayer.layer.shadowRadius = 4
        
        self.shadowLayer.layer.borderWidth = 0.5
        self.shadowLayer.layer.borderColor = UIColor(red: 32/255, green: 206/255, blue: 210/255, alpha: 1).cgColor
        
        self.firstUpView.backgroundColor = UIColor.systemGray6
        self.secondUpView.backgroundColor = UIColor.systemGray6
        self.topStackView.layer.borderWidth = 1.0
        self.topStackView.layer.borderColor = UIColor.systemGray2.cgColor
        self.topStackView.layer.cornerRadius = 10.0
        
    }
    @IBAction func copyButton(_ sender: Any) {
        UIPasteboard.general.string = self.boardSerialNumber.text
    }
    @IBAction func tapDeleteButton(_ sender: Any) {
        delegate?.didTapButton(indexPathNumber: (sender as AnyObject).tag)
    }
}


