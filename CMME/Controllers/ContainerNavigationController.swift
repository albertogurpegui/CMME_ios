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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = email
        /*if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "ContainerNavigationController", sender: nil)
        }else{
            var mainNavigationController : UINavigationController!
            let mainVC = MainViewController(type: false)
            mainNavigationController = UINavigationController(rootViewController: mainVC)
            mainNavigationController.setNavigationBarHidden(true, animated: false)
            self.present(mainVC, animated: false, completion: nil)
        }*/
    }
    
    override func viewDidLoad() {
        setListeners()
    }
    
    func setListeners(){
        NotificationCenter.default.addObserver(self, selector: #selector(signOut), name: NSNotification.Name("signOut"), object: nil)
    }
    
    @objc internal func signOut() {
        try! Auth.auth().signOut()
        let mainVC = MainViewController(type: false)
        //navigationController?.pushViewController(mainVC, animated: true)
        self.present(UINavigationController(rootViewController: mainVC),
                     animated: true,
                     completion: nil)
    }
}
