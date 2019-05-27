//
//  ChatViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 25/05/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

import UIKit
import MessageKit
import MessageInputBar

class ChatViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        let childVC = MessageViewController()
        addChild(childVC)
        self.view.addSubview(childVC.view)
        childVC.didMove(toParent:self)
        self.becomeFirstResponder()
    }
}
