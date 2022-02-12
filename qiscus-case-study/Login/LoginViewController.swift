//
//  LoginViewController.swift
//  qiscus-case-study
//
//  Created by Galang Aji Susanto on 12/02/22.
//

import UIKit
import QiscusCore

class LoginViewController: UIViewController {

    @IBOutlet weak var userIdField: UITextField!
    @IBOutlet weak var userKeyField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let userName = userNameField.text, let userKey = userKeyField.text, let userId = userIdField.text else {return}
        
        QiscusCore.setUser(userId: userId, userKey: userKey, username: userName, avatarURL: nil, extras: nil, onSuccess: { (_) in
            let chatListViewController = ChatListTableViewController()
            self.navigationController?.pushViewController(chatListViewController, animated: true)
        }) { (error) in
            let alert = UIAlertController(title: "Failed to Login?", message: String(describing: error.message), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        
    }
}
