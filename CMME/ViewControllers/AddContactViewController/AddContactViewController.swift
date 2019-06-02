//
//  AddContactViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 29/05/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import SwiftMessages

protocol AddContactViewControllerDelegate: class {
    func addContactViewController(_ vc: AddContactViewController, didEditContact contact: Contact)
    func errorAddContactViewController(_ vc:AddContactViewController)
}

class AddContactViewController: UIViewController {
    
    weak var delegate: AddContactViewControllerDelegate?
    var contactUid: String?
    @IBOutlet weak var gmailsPicker: UIPickerView!
    @IBOutlet weak var gmail: UILabel!
    @IBOutlet weak var viewPopUp: UIView!
    var pickerData: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25){
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gmail.text = ""
        addContactViewControllerDesign()
        Firebase.sharedInstance.getGmailDoctorsOrPatients(completion: { (gmails) in
            self.pickerData = gmails
            self.gmailsPicker.reloadAllComponents()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createButtonPressed() {
        print("Has clickado en añadir")
        if ((gmail.text?.elementsEqual(""))!)  {
            self.delegate?.errorAddContactViewController(self)
        }else{
            Firebase.sharedInstance.contact.sGmailContacto = gmail.text
            Firebase.sharedInstance.addContact()
            self.delegate?.addContactViewController(self, didEditContact: Firebase.sharedInstance.contact)
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
    
    func addContactViewControllerDesign() {
        self.view.setGradientBackground()
        gmailsPicker.isHidden = true
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                gmail.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                gmail.addGestureRecognizer(tapUILabelName)
            case .patient:
                gmail.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                gmail.addGestureRecognizer(tapUILabelName)
            }
        }
        viewPopUp.layer.cornerRadius = 8
        viewPopUp.layer.masksToBounds = true
        gmail.layer.cornerRadius = 8
        gmail.layer.masksToBounds = true
    }
    
    @objc func clickUILabelName(_ sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            gmailsPicker.isHidden = false
        }
    }
}

extension AddContactViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
                gmail.text = pickerData[row]
            case .patient:
                gmail.text = pickerData[row]
            }
        }
    }
}
