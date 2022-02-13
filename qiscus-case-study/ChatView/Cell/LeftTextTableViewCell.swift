//
//  LeftTextTableViewCell.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 13/02/22.
//

import UIKit
import QiscusCore

class LeftTextTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: PaddingLabel!
    
    static let identifier = "LeftTextCell"
    
    var comment: CommentModel? {
        didSet {
            messageLabel.text = comment?.message
        }
    }
    
    func setupUI() {
        messageLabel.layer.cornerRadius = 8
        messageLabel.layer.masksToBounds = true
        self.messageLabel.autoresizingMask = .flexibleWidth
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}
