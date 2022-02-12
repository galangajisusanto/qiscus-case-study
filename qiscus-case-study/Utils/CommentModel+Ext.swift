//
//  CommentModel+Ext.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 12/02/22.
//

import Foundation
import QiscusCore


extension CommentModel {
    func isMyComment() -> Bool {
        if let user = QiscusCore.getProfile() {
            return userEmail == user.email
        }else {
            return false
        }
    }
    
    func date() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone      = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: self.timestamp)
        return date
    }
}
