//
//  RightTextTableViewCell.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 13/02/22.
//

import UIKit
import QiscusCore

class RightTextTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: PaddingLabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    static let identifier = "RightTextCell"
    
    var comment: CommentModel? {
        didSet {
            messageLabel.text = comment?.message
            statusLabel.text = "\(comment?.status.rawValue ?? "") \(comment?.dateTime() ?? "")"
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
