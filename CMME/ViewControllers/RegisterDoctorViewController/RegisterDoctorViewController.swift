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
    
    @IBOutlet weak var imageUser: UIImageView?
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
        self.view.setGradientBackground()
        imageUser?.image = UIImage(named: "addImageUser")
        registerButton?.layer.cornerRadius = 8
        registerButton?.layer.masksToBounds = true
        registerButton?.layer.borderColor = UIColor.white.cgColor
        registerButton?.layer.borderWidth = 1
    }
    
    func isValidEmail(string: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }
    
    @IBAction func executeRegister() {
        if ((nomComplDoctor?.text?.elementsEqual(""))!) || ((contrasennaDoctor?.text?.elementsEqual(""))!) || ((gmailDoctor?.text?.elementsEqual(""))!) ||
            ((hospTrabjDoctor?.text?.elementsEqual(""))!) ||
            ((regisNacdTitDoctor?.text?.elementsEqual(""))!) {
            let alert = UIAlertController(title: "ERROR", message: "Esta erroneo o vacio algun campo", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if isValidEmail(string: gmailDoctor?.text ?? "") == false {
            let alert = UIAlertController(title: "ERROR", message: "El gmail del usuario no es valido", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else{
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
                self.showSpinner(onView: self.view)
                Firebase.sharedInstance.executeRegister(sEmail: sGmail, sContraseña: sContraseña, typeUser: typeUser, completion: {(authdataResult) in
                    let storyboard = UIStoryboard(name: "MainNavigation", bundle: nil)
                    let controller: ContainerNavigationController = storyboard.instantiateViewController(withIdentifier: "ContainerNavigationController") as! ContainerNavigationController
                    controller.email = self.sGmail
                    ContainerNavigationController.userType = .doctor
                    //let tabBarVC = TabBarNavigationController(type:typeUser)
                    self.removeSpinner()
                    self.present(controller, animated: true, completion: nil)
                })
            }
        }
    }
}
