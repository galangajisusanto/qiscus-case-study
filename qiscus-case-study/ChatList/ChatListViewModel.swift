//
//  ChatListViewModel.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 12/02/22.
//

import Foundation
import QiscusCore

class ChatListViewModel {
    
    @Published var rooms = [RoomModel]()
    @Published var error: QError?
    
    func loadChatRoom() {
        QiscusCore.shared.getAllChatRooms(showParticipant: true, showRemoved: false, showEmpty: true, page: 1, limit: 100, onSuccess: { (results, meta) in
            self.rooms = results
        }, onError: { (error) in
            self.error = error
        })
    }
}
