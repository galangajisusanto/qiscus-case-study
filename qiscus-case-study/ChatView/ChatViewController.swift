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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoomDelegate()
        setupObserver()
        setupCommentTable()
        loadChatRoom()
    }

    
    private func setupObserver() {
//        cancellable = chatViewModel.$newComment.sink() { comment in
//
//        }
//        cancellable = chatViewModel.$error.sink() { error in
//            let alert = UIAlertController(title: "Failed", message: String(describing: error?.message), preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
//        }
        
        cancellable = chatViewModel.$comments.sink() { comments in
            self.comments = comments
        }
        
    }
    
    private func setupCommentTable() {
        commentTable.delegate = self
        commentTable.dataSource = self
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
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        let comment = comments[indexPath.row]
        if comment.isMyComment() {
            cell.textLabel?.text = "Pesanku: \(comment.message)"
        } else {
            cell.textLabel?.text = "Pesanmu: \(comment.message)"
        }
        return cell
    }
    
    
}


extension ChatViewController: QiscusCoreRoomDelegate {
    func onMessageReceived(message: CommentModel) {
        comments.append(message)
        let indexPath = IndexPath(item: comments.count, section: 0)
        commentTable.reloadRows(at: [indexPath], with: .top)
    }
    
    func onMessageUpdated(message: CommentModel) {
        
    }
    
    func didComment(comment: CommentModel, changeStatus status: CommentStatus) {
        
    }
    
    func onMessageDelivered(message: CommentModel) {
        
    }
    
    func onMessageRead(message: CommentModel) {
        
    }
    
    func onMessageDeleted(message: CommentModel) {
        
    }
    
    func onUserTyping(userId: String, roomId: String, typing: Bool) {
        
    }
    
    func onUserOnlinePresence(userId: String, isOnline: Bool, lastSeen: Date) {
        
    }
    
    func onRoom(update room: RoomModel) {
        
    }
    

}
