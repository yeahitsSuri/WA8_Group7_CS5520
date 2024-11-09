//
//  ViewController.swift
//  WA8_Group7
//
//  Created by 杨天舒 on 11/9/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate ChatListViewController
        let chatListVC = ChatListViewController()
        
        navigationController?.pushViewController(chatListVC, animated: true)
    }
}
