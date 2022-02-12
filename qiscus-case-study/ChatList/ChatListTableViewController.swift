//
//  ChatListTableViewController.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 12/02/22.
//

import UIKit
import QiscusCore
import Combine

class ChatListTableViewController: UITableViewController {
    
    var rooms = [RoomModel](){
        didSet {
            tableView.reloadData()
        }
    }
    let chatListViewModel = ChatListViewModel()
    var cancellable: Cancellable?
    
    deinit {
        cancellable = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancellable()
        chatListViewModel.loadChatRoom()
    }
    
    private func setupCancellable() {
        cancellable = chatListViewModel.$rooms.sink(){ rooms in
            self.rooms = rooms
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        let room = rooms[indexPath.row]
        cell.textLabel?.text = room.name
        cell.detailTextLabel?.text = "\(room.unreadCount) message unread"
        return cell
    }
}
