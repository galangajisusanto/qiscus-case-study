//
//  ChatListTableViewCell.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 13/02/22.
//

import UIKit
import QiscusCore

class ChatListTableViewCell: UITableViewCell {
    static let identifier = "ChatListCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
    var chatRoom: RoomModel? {
        didSet {
            nameLabel.text = chatRoom?.name
            lastMessageLabel.text = chatRoom?.lastComment?.message
            if let unreadCount = chatRoom?.unreadCount {
                unreadCountLabel.text = "\(unreadCount)"
                if unreadCount == 0 {
                    unreadCountLabel.isHidden = true
                }
            } else {
                unreadCountLabel.isHidden = true
            }
            timelabel.text = chatRoom?.lastComment?.dateTime()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        unreadCountLabel.layer.cornerRadius = 15
        unreadCountLabel.layer.masksToBounds = true
    }
    
}
