//
//  RegisterViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 22/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import Firebase

class RegisterPatientViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var nomComplPatient: UITextField?
    @IBOutlet weak var contrasennaPatient: UITextField?
    @IBOutlet weak var gmailPatient: UITextField?
    @IBOutlet weak var nifPatient: UITextField?
    @IBOutlet weak var tarjSanPatient: UITextField?
    @IBOutlet weak var movilPatient: UITextField?
    @IBOutlet weak var numContPatient: UITextField?
    @IBOutlet weak var registerButton: UIButton?
    
    
    private var sGmail = ""
    private var sContraseña = ""
    private var userType: TypeUser?
    
    convenience init(type typeData: TypeUser) {
        self.init()
        self.userType = typeData
    }
    
    init() {
        super.init(nibName: "RegisterPatientViewController", bundle: nil)
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
        if let gmail = gmailPatient?.text {
            sGmail = gmail
        }
        if let contrasenna = contrasennaPatient?.text {
            sContraseña = contrasenna
        }
        Firebase.sharedInstance.patient.sGmail = gmailPatient?.text
        Firebase.sharedInstance.patient.sNombreCompleto  = nomComplPatient?.text
        Firebase.sharedInstance.patient.sNumNIF  = nifPatient?.text
        Firebase.sharedInstance.patient.sTarjSani = tarjSanPatient?.text
        Firebase.sharedInstance.patient.sNumMovil = movilPatient?.text
        Firebase.sharedInstance.patient.sTlfContact = numContPatient?.text
        if let typeUser = userType {
           Firebase.sharedInstance.executeRegister(sEmail: sGmail, sContraseña: sContraseña, typeUser: typeUser)
            /*let tabBarVC = TabBarNavigationController(type: typeUser)
            self.present(tabBarVC, animated: true, completion: nil)*/
        }
    }
}
