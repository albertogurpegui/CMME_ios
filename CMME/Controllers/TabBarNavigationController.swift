//
//  TabBarController.swift
//  ImagineGamesIOS
//
//  Created by VICTOR ALVAREZ LANTARON on 6/2/19.
//  Copyright © 2019 ImagineGames. All rights reserved.
//

import UIKit

class TabBarNavigationController: UITabBarController {
    
    @IBOutlet weak var signOutButton: UIBarButtonItem?
    let meetingVC = MeetingViewController()
    let prescriptionVC = PrescriptionViewController()
    let hospitalsVC = HospitalsViewController()
    let chatsVC = ChatViewController()
    
    @IBAction func clickSignOut() {
        NotificationCenter.default.post(name: NSNotification.Name("signOut"), object: nil )
    }
    
    init(){
        //self.userType = type
        super.init(nibName: "TabBarNavigationController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        makeTabBar()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            if let typeUser = ContainerNavigationController.userType {
                switch typeUser {
                case .doctor:
                    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: meetingVC, action: #selector(meetingVC.addPressed))
                    
                    self.navigationItem.leftBarButtonItem = addButtonItem
                case .patient:
                    self.navigationItem.leftBarButtonItem = nil
                }
            }
        case 2:
            if let typeUser = ContainerNavigationController.userType {
                switch typeUser {
                case .doctor:
                    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: prescriptionVC, action: #selector(prescriptionVC.addPressed))
                    
                    self.navigationItem.leftBarButtonItem = addButtonItem
                case .patient:
                    self.navigationItem.leftBarButtonItem = nil
                }
            }
        case 3:
            if let typeUser = ContainerNavigationController.userType {
                switch typeUser {
                case .doctor:
                    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: chatsVC, action: #selector(chatsVC.addPressed))
                    
                    self.navigationItem.leftBarButtonItem = addButtonItem
                case .patient:
                    self.navigationItem.leftBarButtonItem = nil
                }
            }
        default:
            break
        }
    }
    
    func makeTabBar() {
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: meetingVC, action: #selector(meetingVC.addPressed))
                
                self.navigationItem.leftBarButtonItem = addButtonItem
                meetingVC.tabBarItem.title = "Citas"
                meetingVC.tabBarItem.tag = 1
                meetingVC.tabBarItem.image = UIImage(named: "Meeting")
                prescriptionVC.tabBarItem.title = "Recetas"
                prescriptionVC.tabBarItem.tag = 2
                prescriptionVC.tabBarItem.image = UIImage(named: "Prescription")
                chatsVC.tabBarItem.title = "Chats"
                chatsVC.tabBarItem.tag = 3
                chatsVC.tabBarItem.image = UIImage(named: "")
                
                self.viewControllers = [meetingVC,
                                        prescriptionVC,
                                        chatsVC]
                
            case .patient:
                let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: meetingVC, action: #selector(meetingVC.addPressed))
                
                self.navigationItem.leftBarButtonItem = addButtonItem
                meetingVC.tabBarItem.title = "Citas"
                meetingVC.tabBarItem.tag = 1
                meetingVC.tabBarItem.image = UIImage(named: "Meeting")
                prescriptionVC.tabBarItem.title = "Recetas"
                prescriptionVC.tabBarItem.tag = 2
                prescriptionVC.tabBarItem.image = UIImage(named: "Prescription")
                hospitalsVC.tabBarItem.title = "Hospitales"
                hospitalsVC.tabBarItem.tag = 3
                hospitalsVC.tabBarItem.image = UIImage(named: "Hospital")
                chatsVC.tabBarItem.title = "Chats"
                chatsVC.tabBarItem.tag = 4
                chatsVC.tabBarItem.image = UIImage(named: "")
                
                self.viewControllers = [meetingVC,
                                        prescriptionVC,
                                        hospitalsVC,
                                        chatsVC]
            }
        }
    }
}
