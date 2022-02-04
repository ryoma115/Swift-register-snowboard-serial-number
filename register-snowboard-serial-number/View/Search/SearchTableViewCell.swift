//
//  SearchTableViewCell.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/28.
//

import UIKit
import SDWebImage

//MARK: protocol
protocol SearchTableViewCellDelegate:AnyObject {
    func didTapButton(indexPathNumber:Int)
}

class SearchTableViewCell: UITableViewCell {
    
    var delegate: SearchTableViewCellDelegate?

//MARK: @IBOutlet
    @IBOutlet private weak var boardImage: UIImageView!
    @IBOutlet private weak var boardBrand: UILabel!
    @IBOutlet private weak var boardSerialNumber: UILabel!
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var userID: UILabel!
    @IBOutlet private weak var dateID: UILabel!
    @IBOutlet private weak var shadowLayer: UIView!
    @IBOutlet weak var foundButton: UIButton!
    @IBOutlet private weak var copyButton: UIButton!
    
    @IBOutlet private weak var firstUpView: UIView!
    @IBOutlet private weak var firstDownView: UIView!
    @IBOutlet private weak var secondUpView: UIView!
    @IBOutlet private weak var secondDownView: UIView!
    @IBOutlet private weak var topStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        foundButton.layer.cornerRadius = 8
    }
    func setUp(acceptData:AcceptData){
        self.backgroundColor = .systemGray5
        
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
        
        fullName.text = acceptData.fullName
        userID.text = acceptData.userID
        boardSerialNumber.text = acceptData.boardSerialNumber
        boardBrand.text = acceptData.boardBrand
        dateID.text = String(acceptData.postDate)
        boardImage.sd_setImage(with: URL(string: acceptData.boardImageUrl), completed: nil)
        
        if acceptData.lost == false{
            foundButton.isHidden = true
        }
    }

//MARK: @IBAction
    @IBAction private func tapFoundButton(_ sender: Any) {
        delegate?.didTapButton(indexPathNumber: (sender as AnyObject).tag)
    }
    @IBAction private func copyButton(_ sender: Any) {
        UIPasteboard.general.string = boardSerialNumber.text
    }
}


