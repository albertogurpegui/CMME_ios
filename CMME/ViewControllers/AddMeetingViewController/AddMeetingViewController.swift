//
//  AddViewController.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

protocol AddMeetingViewControllerDelegate: class {
    func addMeetingViewController(_ vc: AddMeetingViewController, didEditMeeting meeting: Meeting)
    func errorAddMeetingViewController(_ vc:AddMeetingViewController)
}

class AddMeetingViewController: UIViewController {
    
    @IBOutlet weak var namesPicker: UIPickerView!
    @IBOutlet weak var dateCalendar: UIDatePicker!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var namePatient: UILabel!
    @IBOutlet weak var nameDoctor: UILabel!
    @IBOutlet weak var siteConsultion: UITextField!
    @IBOutlet weak var dateConsultion: UILabel!
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
        siteConsultion.text = ""
        dateConsultion.text = ""
        descriptionMeeting.text = ""
        addMeetingViewControllerDesign()
        Firebase.sharedInstance.getNameDoctorsOrPatients(completion: { (names) in
            self.pickerData = names
            self.namesPicker.reloadAllComponents()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createButtonPressed() {
        print("Has clickado en añadir")
        if ((namePatient.text?.elementsEqual(""))!) || ((nameDoctor.text?.elementsEqual(""))!) || ((descriptionMeeting.text?.elementsEqual(""))!) || ((siteConsultion.text?.elementsEqual(""))!) || ((dateConsultion.text?.elementsEqual(""))!) {
            self.delegate?.errorAddMeetingViewController(self)
        }else{
            Firebase.sharedInstance.meeting.sNombreDoctorCompleto = nameDoctor.text
            Firebase.sharedInstance.meeting.sNombrePacienteCompleto = namePatient.text
            Firebase.sharedInstance.meeting.sDescripcionCita = descriptionMeeting.text
            Firebase.sharedInstance.meeting.sSalaCita = siteConsultion.text
            Firebase.sharedInstance.meeting.sFechaCita = dateConsultion.text
            Firebase.sharedInstance.addMeeting()
            self.delegate?.addMeetingViewController(self, didEditMeeting: Firebase.sharedInstance.meeting)
        }
    }
    
    @IBAction func cancelButtonPressed() {
        UIView.animate(withDuration: 0.25, animations: { self.view.backgroundColor = UIColor.clear }) { (bool) in
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.warning)
            view.configureDropShadow()
            let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.layer.cornerRadius = 10
            view.configureContent(title: "Warning", body: "Pulsa Ok para volver a la lista de citas (No se guardaran los datos)", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Ok", buttonTapHandler: { (button) in
                self.navigationController?.popViewController(animated: true)
            })
            //view.configureContent(title: "Warning", body: "Volviste atrás", iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    
    func addMeetingViewControllerDesign() {
        self.view.setGradientBackground()
        namesPicker.isHidden = true
        dateCalendar.isHidden = true
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                nameDoctor.text = Firebase.sharedInstance.doctor.sNombreCompleto
                namePatient.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                namePatient.addGestureRecognizer(tapUILabelName)
                dateConsultion.isUserInteractionEnabled = true
                let tapUILabelDate = UITapGestureRecognizer(target: self, action: #selector(clickUILabelDate(_:)))
                dateConsultion.addGestureRecognizer(tapUILabelDate)
            case .patient:
                namePatient.text = Firebase.sharedInstance.patient.sNombreCompleto
                nameDoctor.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                nameDoctor.addGestureRecognizer(tapUILabelName)
                dateConsultion.isUserInteractionEnabled = true
                let tapUILabelDate = UITapGestureRecognizer(target: self, action: #selector(clickUILabelDate(_:)))
                dateConsultion.addGestureRecognizer(tapUILabelDate)
            }
        }
        
        let tapEverythingInsteadOfUILabelNameDate = UITapGestureRecognizer(target: self, action: #selector(clickEverythingInsteadOfUILabelNameDate(_:)))
        descriptionMeeting.addGestureRecognizer(tapEverythingInsteadOfUILabelNameDate)
        viewPopup.layer.cornerRadius = 8
        viewPopup.layer.masksToBounds = true
        nameDoctor.layer.cornerRadius = 8
        nameDoctor.layer.masksToBounds = true
        namePatient.layer.cornerRadius = 8
        namePatient.layer.masksToBounds = true
        descriptionMeeting.layer.cornerRadius = 8
        descriptionMeeting.layer.masksToBounds = true
        siteConsultion.layer.cornerRadius = 8
        siteConsultion.layer.masksToBounds = true
        dateConsultion.layer.cornerRadius = 8
        dateConsultion.layer.masksToBounds = true
    }
    
    func datePickerValueChanged (datePicker: UIDatePicker) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        dateConsultion.text = dateformatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func clickUILabelName(_ sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            namesPicker.isHidden = false
            dateCalendar.isHidden = true
        }
    }
    
    @objc func clickEverythingInsteadOfUILabelNameDate(_ sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            namesPicker.isHidden = true
            dateCalendar.isHidden = true
        }
    }
    
    @objc func clickUILabelDate(_ sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            namesPicker.isHidden = true
            dateCalendar.isHidden = false
            datePickerValueChanged(datePicker: dateCalendar)
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
