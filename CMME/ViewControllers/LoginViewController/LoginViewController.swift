//
//  LoginViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 22/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var gmailUser: UITextField?
    @IBOutlet weak var contrasennaUser: UITextField?
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var loginButton: UIButton?
    
    private var sEmail = "alberto.gurpegui@gmail.com"
    private var sContraseña = "123456789"
    private var userType: TypeUser?

    
    convenience init(type typeData: TypeUser) {
        self.init()
        self.userType = typeData
    }

    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        backgroundView?.setGradientBackground()
        loginButton?.layer.cornerRadius = 8
        loginButton?.layer.masksToBounds = true
        loginButton?.layer.borderColor = UIColor.white.cgColor
        loginButton?.layer.borderWidth = 1
    }
    
    @IBAction func executeLogin() {
        print("Esta en data holder")
        /*if let gmail = gmailUser?.text{
            sEmail = gmail
        }
        if let contrasenna = contrasennaUser?.text {
            sContraseña = contrasenna
        }*/
        if let typeUser = userType {
            switch typeUser {
            case .doctor:
                self.showSpinner(onView: self.view)
                Firebase.sharedInstance.executeLogin(sEmail: sEmail, sContraseña: sContraseña, typeUser: typeUser, completion: {(authdataResult) in
                    let storyboard = UIStoryboard(name: "MainNavigation", bundle: nil)
                    let controller: ContainerNavigationController = storyboard.instantiateViewController(withIdentifier: "ContainerNavigationController") as! ContainerNavigationController
                    controller.email = self.sEmail
                    ContainerNavigationController.userType = .doctor
                    //let tabBarVC = TabBarNavigationController(type:typeUser)
                    self.present(controller, animated: true, completion: nil)
                    self.removeSpinner()
                })
            case .patient:
                self.showSpinner(onView: self.view)
                Firebase.sharedInstance.executeLogin(sEmail: sEmail, sContraseña: sContraseña, typeUser: typeUser, completion: {(authdataResult) in
                    let storyboard = UIStoryboard(name: "MainNavigation", bundle: nil)
                    let controller: ContainerNavigationController = storyboard.instantiateViewController(withIdentifier: "ContainerNavigationController") as! ContainerNavigationController
                    controller.email = self.sEmail
                    ContainerNavigationController.userType = .patient
                    //let tabBarVC = TabBarNavigationController(type:typeUser)
                    self.present(controller, animated: true, completion: nil)
                    self.removeSpinner()
                })
            }
        }
    }
}
