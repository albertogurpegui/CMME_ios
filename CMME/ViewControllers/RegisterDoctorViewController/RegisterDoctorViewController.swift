//
//  RegisterViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 22/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import Firebase

class RegisterDoctorViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var nomComplDoctor: UITextField?
    @IBOutlet weak var contrasennaDoctor: UITextField?
    @IBOutlet weak var gmailDoctor: UITextField?
    @IBOutlet weak var hospTrabjDoctor: UITextField?
    @IBOutlet weak var regisNacdTitDoctor: UITextField?
    @IBOutlet weak var registerButton: UIButton?
    
    
    private var sGmail = ""
    private var sContraseña = ""
    private var userType: TypeUser?
    
    convenience init(type typeData: TypeUser) {
        self.init()
        self.userType = typeData
    }
    
    init() {
        super.init(nibName: "RegisterDoctorViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        backgroundView?.setGradientBackground()
        registerButton?.layer.cornerRadius = 8
        registerButton?.layer.masksToBounds = true
        registerButton?.layer.borderColor = UIColor.white.cgColor
        registerButton?.layer.borderWidth = 1
    }
    
    @IBAction func executeRegister() {
        if let gmail = gmailDoctor?.text {
            sGmail = gmail
        }
        if let contrasenna = contrasennaDoctor?.text {
            sContraseña = contrasenna
        }
        Firebase.sharedInstance.doctor.sGmail = gmailDoctor?.text
        Firebase.sharedInstance.doctor.sNombreCompleto  = nomComplDoctor?.text
        Firebase.sharedInstance.doctor.sHospTrabaj  = hospTrabjDoctor?.text
        Firebase.sharedInstance.doctor.sRegisNacTitu = regisNacdTitDoctor?.text
        if let typeUser = userType {
            Firebase.sharedInstance.executeRegister(sEmail: sGmail, sContraseña: sContraseña, typeUser: typeUser)
            let tabBarVC = TabBarNavigationController(type: typeUser)
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
}
