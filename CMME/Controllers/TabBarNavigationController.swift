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
    let patientsVC = PatientsViewController()
    let hospitalsVC = HospitalsViewController()
    
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
    
    func makeTabBar() {
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                
                let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: meetingVC, action: #selector(meetingVC.addPressed))
         
                self.navigationItem.leftBarButtonItem = addButtonItem
                meetingVC.tabBarItem.title = "Citas"
                meetingVC.tabBarItem.image = UIImage(named: "Meeting")
                prescriptionVC.tabBarItem.title = "Recetas"
                prescriptionVC.tabBarItem.image = UIImage(named: "Prescription")
                patientsVC.tabBarItem.title = "Pacientes"
                patientsVC.tabBarItem.image = UIImage(named: "")
                
                self.viewControllers = [meetingVC,
                                        prescriptionVC,
                                        patientsVC]
                
            case .patient:
                
                let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: meetingVC, action: #selector(meetingVC.addPressed))
         
                self.navigationItem.leftBarButtonItem = addButtonItem
                meetingVC.tabBarItem.title = "Citas"
                meetingVC.tabBarItem.image = UIImage(named: "Meeting")
                prescriptionVC.tabBarItem.title = "Recetas"
                prescriptionVC.tabBarItem.image = UIImage(named: "Prescription")
                hospitalsVC.tabBarItem.title = "Hospitales"
                hospitalsVC.tabBarItem.image = UIImage(named: "")
                
                self.viewControllers = [meetingVC,
                                        prescriptionVC,
                                        hospitalsVC]
            }
        }
    }
}
