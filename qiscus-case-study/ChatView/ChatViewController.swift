//
//  ChatViewController.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 12/02/22.
//

import UIKit
import QiscusCore
import Combine

class ChatViewController: UIViewController {
    
    var room: RoomModel?
    var cancellable: Cancellable?
    var errroCancellable: Cancellable?
    let chatViewModel = ChatViewModel()
    var comments = [CommentModel]() {
        didSet {
            commentTable.reloadData()
        }
    }
    
    @IBOutlet weak var commentTextArea: UITextView!
    @IBOutlet weak var commentTable: UITableView!
    
    deinit {
        removeRoomDelegate()
        cancellable = nil
        errroCancellable = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoomDelegate()
        setupObserver()
        setupCommentTable()
        setupView()
        loadChatRoom()
    }
    
    private func setupView() {
        commentTextArea.layer.cornerRadius = 16
        commentTextArea.layer.masksToBounds = true
        title = room?.name
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "PrimaryColor")]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.tintColor = UIColor(named: "PrimaryColor")
    }
    
    
    private func setupObserver() {
        
        errroCancellable = chatViewModel.$error.dropFirst().sink() { error in
            let alert = UIAlertController(title: "Failed", message: String(describing: error?.message ?? ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        cancellable = chatViewModel.$comments.dropFirst().sink() { comments in
            if !comments.isEmpty {
                self.comments = comments
                let indexPath = IndexPath(item: comments.count - 1, section: 0)
                self.commentTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
    }
    
    private func setupCommentTable() {
        commentTable.delegate = self
        commentTable.dataSource = self
        let rightTextUiNib = UINib(nibName: "\(RightTextTableViewCell.self)", bundle: nil)
        commentTable.register(rightTextUiNib, forCellReuseIdentifier: RightTextTableViewCell.identifier)
        let leftTextUiNib = UINib(nibName: "\(LeftTextTableViewCell.self)", bundle: nil)
        commentTable.register(leftTextUiNib, forCellReuseIdentifier: LeftTextTableViewCell.identifier)
    }
    
    @IBAction func attachmentButtonTapped(_ sender: UIButton) {
        print("attachment button tapped")
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let comment = commentTextArea.text else {
            let alert = UIAlertController(title: "Failled", message: "Pesan anda masih kosong", preferredStyle: .alert)
            self.present(alert, animated: true)
            return
        }
        
        guard let roomId = room?.id else {return}
        chatViewModel.sendMessage(message: comment, roomId: roomId)
        commentTextArea.text = ""
    }
    
    func setRoomDelegate(){
        if let room = self.room {
            room.delegate = self
        }
    }
    
    func removeRoomDelegate() {
        if let room = self.room {
            room.delegate = nil
        }
    }
    
    func loadChatRoom() {
        guard let roomId = room?.id else { return }
        chatViewModel.loadChatRoom(roomId: roomId)
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        if comment.isMyComment() {
            let reuseCell = tableView.dequeueReusableCell(withIdentifier: RightTextTableViewCell.identifier, for: indexPath)
            if let cell = reuseCell as? RightTextTableViewCell {
                cell.comment = comment
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let reuseCell = tableView.dequeueReusableCell(withIdentifier: LeftTextTableViewCell.identifier, for: indexPath)
            if let cell = reuseCell as? LeftTextTableViewCell {
                cell.comment = comment
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}


extension ChatViewController: QiscusCoreRoomDelegate {
    func onMessageReceived(message: CommentModel) {
        comments.append(message)
        let indexPath = IndexPath(item: comments.count - 1, section: 0)
        commentTable.reloadRows(at: [indexPath], with: .top)
        commentTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func onMessageUpdated(message: CommentModel) {
        reloadMessage(message)
    }
    
    func didComment(comment: CommentModel, changeStatus status: CommentStatus) {
        
    }
    
    func onMessageDelivered(message: CommentModel) {
        reloadMessage(message)
    }
    
    func onMessageRead(message: CommentModel) {
        reloadMessage(message)
    }
    
    func onMessageDeleted(message: CommentModel) {
        
    }
    
    func onUserTyping(userId: String, roomId: String, typing: Bool) {
        
    }
    
    func onUserOnlinePresence(userId: String, isOnline: Bool, lastSeen: Date) {
        
    }
    
    func onRoom(update room: RoomModel) {
        
    }
    
    private func reloadMessage(_ message: CommentModel) {
        let index = comments.firstIndex{$0.id == message.id}
        guard let commnetIndex = index else { return }
        let indexPath = IndexPath(item: commnetIndex, section: 0)
        commentTable.reloadRows(at: [indexPath], with: .none)
    }
    
    
}
