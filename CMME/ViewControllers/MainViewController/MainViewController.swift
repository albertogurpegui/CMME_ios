//
//  LoginViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 21/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var logoApp: UIImageView?
    @IBOutlet weak var titleApp: UILabel?
    @IBOutlet weak var doctorView: UIView?
    @IBOutlet weak var logoDoctor: UIImageView?
    @IBOutlet weak var titleDoctor: UILabel?
    @IBOutlet weak var patientView: UIView?
    @IBOutlet weak var logoPacient: UIImageView?
    @IBOutlet weak var titlePacient: UILabel?
    @IBOutlet weak var buttonRegister: UIButton?
    private var regitro: Bool?
    private var dataType: TypeUser?

    @IBAction func clickRegisterButton() {
        let mainRegisterVC = MainViewController(type: true)
        navigationController?.pushViewController(mainRegisterVC, animated: true)
    }
    
    convenience init(type: Bool) {
        self.init()
        self.regitro = type
    }
    
    init() {
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if let type = regitro {
            switch type {
            case true:
                self.navigationController?.setNavigationBarHidden(false, animated: false)
            case false:
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewControllerDesign()
        tapInUIViews()
        if let type = regitro {
            buttonRegister?.isHidden = type
        }
    }
    
    func mainViewControllerDesign() {
        backgroundView?.setGradientBackground()
        logoApp?.image = UIImage(named: "Logo")
        titleApp?.text = "CMME"
        doctorView?.layer.cornerRadius = 8
        doctorView?.layer.masksToBounds = true
        doctorView?.layer.borderColor = UIColor.white.cgColor
        doctorView?.layer.borderWidth = 1
        logoDoctor?.image = UIImage(named: "Nurse")
        patientView?.layer.cornerRadius = 8
        patientView?.layer.masksToBounds = true
        patientView?.layer.borderColor = UIColor.white.cgColor
        patientView?.layer.borderWidth = 1
        logoPacient?.image = UIImage(named: "User")
        buttonRegister?.layer.cornerRadius = 8
        buttonRegister?.layer.masksToBounds = true
        buttonRegister?.layer.borderColor = UIColor.white.cgColor
        buttonRegister?.layer.borderWidth = 1
        buttonRegister?.setTitle("REGISTRARTE", for: .normal)
        if let type = regitro {
            switch type {
            case true:
                titleDoctor?.text = "Registrarte \ncomo Doctor"
                titlePacient?.text = "Registrarte como Paciente"
            case false:
                titleDoctor?.text = "Entrar como \nDoctor"
                titlePacient?.text = "Entrar como Paciente"
            }
        }
    }
    
    func tapInUIViews() {
        let gestureDoctor = UITapGestureRecognizer(target: self, action:  #selector(clickUIViewDoctor(_:)))
        let gesturePatient = UITapGestureRecognizer(target: self, action:  #selector(clickUIViewPatient(_:)))
        doctorView?.addGestureRecognizer(gestureDoctor)
        doctorView?.isUserInteractionEnabled = true
        patientView?.addGestureRecognizer(gesturePatient)
        patientView?.isUserInteractionEnabled = true
    }
    
    @objc func clickUIViewDoctor(_ sender:UITapGestureRecognizer){
        print("Doctor")
        if let type = regitro {
            switch type {
            case true:
                let registerVC = RegisterDoctorViewController(type: .doctor)
                navigationController?.pushViewController(registerVC, animated: true)
            case false:
                let loginVC = LoginViewController(type: .doctor)
                navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    
    @objc func clickUIViewPatient(_ sender:UITapGestureRecognizer){
        print("Paciente")
        if let type = regitro {
            switch type {
            case true:
                let registerVC = RegisterPatientViewController(type: .patient)
                navigationController?.pushViewController(registerVC, animated: true)
            case false:
                let loginVC = LoginViewController(type: .patient)
                navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
}
