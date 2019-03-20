//
//  AddViewController.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import UIKit
import Firebase

protocol AddMeetingViewControllerDelegate: class {
    func addMeetingViewController(_ vc: AddMeetingViewController, didEditMeeting meeting: Meeting)
    func errorAddMeetingViewController(_ vc:AddMeetingViewController)
}

class AddMeetingViewController: UIViewController {
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var namePatient: UITextField!
    @IBOutlet weak var nameDoctor: UITextField!
    @IBOutlet weak var descriptionMeeting: UITextField!
    weak var delegate: AddMeetingViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25){
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.layer.cornerRadius = 8
        viewPopup.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createButtonPressed() {
        print("Has clickado en añadir")
        if ((namePatient.text?.elementsEqual(""))!) || ((nameDoctor.text?.elementsEqual(""))!) || ((descriptionMeeting.text?.elementsEqual(""))!) {
            self.delegate?.errorAddMeetingViewController(self)
        }else{
            Firebase.sharedInstance.meeting.sNombreDoctorCompleto = nameDoctor.text
            Firebase.sharedInstance.meeting.sNombrePacienteCompleto = namePatient.text
            Firebase.sharedInstance.meeting.sDescripcionCita = descriptionMeeting.text
            Firebase.sharedInstance.addMeeting()
            self.delegate?.addMeetingViewController(self, didEditMeeting: Firebase.sharedInstance.meeting)
            
        }
    }
    
    @IBAction func cancelButtonPressed() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.clear
        }) { (bool) in
            self.dismiss(animated: true)
        }
    }
}

