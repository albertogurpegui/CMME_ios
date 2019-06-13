//
//  ContainerNavigationController.swift
//  ImagineGamesIOS
//
//  Created by VICTOR ALVAREZ LANTARON on 6/2/19.
//  Copyright © 2019 ImagineGames. All rights reserved.
//

import UIKit
import Firebase

class ContainerNavigationController: UIViewController {
    var email: String?
    static var userType: TypeUser?
    private var mainNavigationController : UINavigationController!
    
    init() {
        super.init(nibName: "ContainerNavigationController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setListeners()
    }
    
    func setListeners(){
        NotificationCenter.default.addObserver(self, selector: #selector(signOut), name: NSNotification.Name("signOut"), object: nil)
    }
    
    @objc internal func signOut() {
        try! Auth.auth().signOut()
        Firebase.sharedInstance.user = nil
        let mainVC = MainViewController(type: false)
        self.present(UINavigationController(rootViewController: mainVC),
                     animated: true,
                     completion: nil)
    }
}
