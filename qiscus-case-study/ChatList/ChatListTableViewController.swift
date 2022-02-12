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
        setupObserver()
        chatListViewModel.loadChatRoom()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
        QiscusCore.clearUser { (error) in
            let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            sceneDelegate?.auth()
        }
    }
    
    private func setupObserver() {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        let chatViewController = ChatViewController()
        chatViewController.room = room
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
