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
    
    private var sEmail = ""
    private var sContraseña = ""
    private var type: String?
    
    convenience init(typeUser: String) {
        self.init()
        self.type = typeUser
    }

    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView?.setGradientBackground()
        loginButton?.layer.cornerRadius = 8
        loginButton?.layer.masksToBounds = true
        loginButton?.layer.borderColor = UIColor.white.cgColor
        loginButton?.layer.borderWidth = 1
    }
    
    @IBAction func executeLogin() {
        print("Esta en data holder")
        if let gmail = gmailUser?.text{
            sEmail = gmail
        }
        if let contrasenna = contrasennaUser?.text {
            sContraseña = contrasenna
        }
        if let typeUser = type {
            switch typeUser {
            case "Doctor":
                Firebase.sharedInstance.executeLogin(sEmail: sEmail, sContraseña: sContraseña, typeUser: typeUser)
            case "Patient":
                Firebase.sharedInstance.executeLogin(sEmail: sEmail, sContraseña: sContraseña, typeUser: typeUser)
            default:
                break
            }
        }
    }
}
