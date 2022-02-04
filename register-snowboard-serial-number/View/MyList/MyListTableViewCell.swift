//
//  MyListTableViewCell.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/14.
//

import UIKit

//MARK: protocol
protocol MyListTableViewCellDelegate: AnyObject {
    func didTapButton(indexPathNumber:Int)
}

class MyListTableViewCell: UITableViewCell {
    
    var delegate:MyListTableViewCellDelegate?
    
//MARK: @IBOutlet
    @IBOutlet private var boardImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet private var lostLabel: UILabel!
    @IBOutlet weak var lostSwitch: UISwitch!
    @IBOutlet private var boardBrand: UILabel!
    @IBOutlet private var boardSerialNumber: UILabel!
    @IBOutlet private var copyButton: UIButton!
    @IBOutlet private var fullName: UILabel!
    @IBOutlet private var userID: UILabel!
    @IBOutlet private var dateID: UILabel!
    
    @IBOutlet private var shadowLayer: UIView!
    @IBOutlet private var firstUpView: UIView!
    @IBOutlet private var firstDownView: UIView!
    @IBOutlet private var secondUpView: UIView!
    @IBOutlet private var secondDownView: UIView!
    @IBOutlet private var topStackView: UIStackView!
    
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
        
        self.firstUpView.backgroundColor = UIColor.systemGray6
        self.secondUpView.backgroundColor = UIColor.systemGray6
        self.topStackView.layer.borderWidth = 1.0
        self.topStackView.layer.borderColor = UIColor.systemGray2.cgColor
        self.topStackView.layer.cornerRadius = 10.0
        
    }
    
//MARK: @IBAction
    @IBAction func copyButton(_ sender: Any) {
        UIPasteboard.general.string = self.boardSerialNumber.text
    }
    @IBAction func tapDeleteButton(_ sender: Any) {
        delegate?.didTapButton(indexPathNumber: (sender as AnyObject).tag)
    }
}


