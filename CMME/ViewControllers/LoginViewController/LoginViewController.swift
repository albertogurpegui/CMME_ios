//
//  LoginViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 22/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class LoginViewController: UIViewController {
    
    @IBOutlet weak var gmailUser: UITextField?
    @IBOutlet weak var contrasennaUser: UITextField?
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var loginButton: UIButton?
    /*private var sEmail = ""
    private var sContraseña = ""*/
    private var sEmail = "alberto.gurpegui@gmail.com"
    private var sContraseña = "123456789"
    /*private var sEmail = "jesus.gomez@doctor.com"
    private var sContraseña = "123456789"*/
    private var userType: TypeUser?
    let animationView = AnimationView()
    
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
        if ((gmailUser?.text?.elementsEqual(""))!) || ((contrasennaUser?.text?.elementsEqual(""))!) {
            let alert = UIAlertController(title: "ERROR", message: "Esta erroneo o vacio algun campo", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if let gmail = gmailUser?.text{
                sEmail = gmail
            }
            if let contrasenna = contrasennaUser?.text {
                sContraseña = contrasenna
            }
            if let typeUser = userType {
                let animation = Animation.named("animation-w500-h500")
                switch typeUser {
                case .doctor:
                    Firebase.sharedInstance.executeLogin(sEmail: sEmail, sContraseña: sContraseña, typeUser: typeUser, completion: {(authdataResult) in
                        self.animationView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
                        self.animationView.animation = animation
                        self.animationView.contentMode = .scaleAspectFit
                        self.animationView.play(fromProgress: 0,
                                                toProgress: 1,
                                                loopMode: LottieLoopMode.playOnce,
                                                completion: { (finished) in
                                                    if finished {
                                                        let storyboard = UIStoryboard(name: "MainNavigation", bundle: nil)
                                                        let controller: ContainerNavigationController = storyboard.instantiateViewController(withIdentifier: "ContainerNavigationController") as! ContainerNavigationController
                                                        controller.email = self.sEmail
                                                        ContainerNavigationController.userType = .doctor
                                                        self.animationView.stop()
                                                        self.present(controller, animated: true, completion: nil)
                                                    } else {
                                                        print("Animation cancelled")
                                                    }
                        })
                        
                        self.backgroundView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
                        self.backgroundView?.addSubview(self.animationView)
                    })
                case .patient:
                    Firebase.sharedInstance.executeLogin(sEmail: sEmail, sContraseña: sContraseña, typeUser: typeUser, completion: {(authdataResult) in
                        self.animationView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
                        self.animationView.animation = animation
                        self.animationView.contentMode = .scaleAspectFit
                        self.animationView.play(fromProgress: 0,
                                                toProgress: 1,
                                                loopMode: LottieLoopMode.playOnce,
                                                completion: { (finished) in
                                                    if finished {
                                                        let storyboard = UIStoryboard(name: "MainNavigation", bundle: nil)
                                                        let controller: ContainerNavigationController = storyboard.instantiateViewController(withIdentifier: "ContainerNavigationController") as! ContainerNavigationController
                                                        controller.email = self.sEmail
                                                        ContainerNavigationController.userType = .patient
                                                        self.animationView.stop()
                                                        self.present(controller, animated: true, completion: nil)
                                                    } else {
                                                        print("Animation cancelled")
                                                    }
                        })
                        
                        self.backgroundView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
                        self.backgroundView?.addSubview(self.animationView)
                    })
                }
            }
        }
    }
}
