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
    
    @IBOutlet weak var names: UIPickerView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var namePatient: UILabel!
    @IBOutlet weak var nameDoctor: UILabel!
    @IBOutlet weak var descriptionMeeting: UITextField!
    weak var delegate: AddMeetingViewControllerDelegate?
    var pickerData: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25){
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameDoctor.text = ""
        namePatient.text = ""
        addMeetingViewControllerDesign()
        Firebase.sharedInstance.getNameDoctorsOrPatients(completion: { (namesDoctors) in
            self.pickerData = namesDoctors
            self.names.reloadAllComponents()
        })
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
    
    func addMeetingViewControllerDesign() {
        self.view.setGradientBackground()
        names.isHidden = true
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                nameDoctor.text = Firebase.sharedInstance.doctor.sNombreCompleto
                namePatient.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                namePatient.addGestureRecognizer(tapUILabelName)
            case .patient:
                namePatient.text = Firebase.sharedInstance.patient.sNombreCompleto
                nameDoctor.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                nameDoctor.addGestureRecognizer(tapUILabelName)
            }
        }
        
        let tapEverythingInsteadOfUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickEverythingInsteadOfUILabelName(_:)))
        descriptionMeeting.addGestureRecognizer(tapEverythingInsteadOfUILabelName)
        
        nameDoctor.layer.cornerRadius = 8
        nameDoctor.layer.masksToBounds = true
        namePatient.layer.cornerRadius = 8
        namePatient.layer.masksToBounds = true
        descriptionMeeting.layer.cornerRadius = 8
        descriptionMeeting.layer.masksToBounds = true
        viewPopup.layer.cornerRadius = 8
        viewPopup.layer.masksToBounds = true
    }
    
    @objc func clickUILabelName(_ sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            names.isHidden = false
        }
    }
    
    @objc func clickEverythingInsteadOfUILabelName(_ sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            names.isHidden = true
        }
    }
}

extension AddMeetingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                namePatient.text = pickerData[row]
            case .patient:
                nameDoctor.text = pickerData[row]
            }
        }
    }
}
