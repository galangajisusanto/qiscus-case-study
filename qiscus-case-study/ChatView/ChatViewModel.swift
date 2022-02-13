//
//  ChatViewModel.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 12/02/22.
//

import Foundation
import QiscusCore

class ChatViewModel {
    @Published var error: QError?
    @Published var comments = [CommentModel]()
    
    
    func sendMessage(message text: String, roomId: String) {
        let message = CommentModel()
        message.message = text
        message.type    = "text"
        message.roomId  = roomId
        message.extras  = nil
        
        QiscusCore.shared.sendMessage(message: message, onSuccess: { (_) in
        }) { (error) in
            self.error = error
        }
    }
    
    func loadChatRoom(roomId: String) {
        QiscusCore.shared.getChatRoomWithMessages(roomId: roomId, onSuccess: { [weak self] (room,comments) in
            self?.comments = comments.reversed()
        }) { [weak self] (error) in
            self?.error = error
        }
    }
}
