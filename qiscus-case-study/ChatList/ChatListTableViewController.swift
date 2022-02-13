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
    var errorCancellable: Cancellable?
    
    
    deinit {
        cancellable = nil
        errorCancellable = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupCell()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatListViewModel.loadChatRoom()
    }
    
    private func setupCell() {
        let uiNib = UINib(nibName: "\(ChatListTableViewCell.self)", bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: ChatListTableViewCell.identifier)
    }
    
    private func setupObserver() {
        cancellable = chatListViewModel.$rooms.dropFirst().sink(){ rooms in
            if !rooms.isEmpty {
                self.rooms = rooms
            }
        }
        errorCancellable = chatListViewModel.$error.dropFirst().sink(){ error in
            let alert = UIAlertController(title: "Failed", message: String(describing: error?.message ?? ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PrimaryColor")
    }
    
    @objc func logoutTapped() {
        QiscusCore.clearUser { (error) in
            let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            sceneDelegate?.auth()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = rooms[indexPath.row]
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier, for: indexPath)
        if let cell = reuseCell as? ChatListTableViewCell {
            cell.chatRoom = room
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        let chatViewController = ChatViewController()
        chatViewController.room = room
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
