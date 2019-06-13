//
//  AddPrescriptionViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 09/06/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import SwiftMessages
import FirebaseStorage

protocol AddPrescriptionViewControllerDelegate: class {
    func addPrescriptionViewController(_ vc: AddPrescriptionViewController, didEditPrescription prescription: Prescription)
    func errorAddPrescriptionViewController(_ vc:AddPrescriptionViewController)
}

class AddPrescriptionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: AddPrescriptionViewControllerDelegate?
    @IBOutlet weak var gmailsPicker: UIPickerView!
    @IBOutlet weak var gmail: UILabel!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var presciptionImage: UIImageView!
    var pickerData: [String] = []
    //var imageData: Data?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25){
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gmail.text = ""
        addPrescriptionViewControllerDesign()
        Firebase.sharedInstance.getGmailDoctorsOrPatients(completion: { (gmails) in
            self.pickerData = gmails
            self.gmailsPicker.reloadAllComponents()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func clickUIImagePrescription () {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            presciptionImage.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel image")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed() {
        print("Has clickado en añadir")
        if ((gmail.text?.elementsEqual(""))!)  {
            self.delegate?.errorAddPrescriptionViewController(self)
        }else{
            Firebase.sharedInstance.prescription.sGmailPaciente = gmail.text
            Firebase.sharedInstance.prescription.sGmailDoctor = Firebase.sharedInstance.user?.email
            var downloadURL:String = ""
            let tiempoMilis:Int = Int((Date().timeIntervalSince1970 * 1000.0).rounded())
            let rutaStorage:String = String(format: "prescription%d.jpeg", tiempoMilis)
            let storageRef = Firebase.sharedInstance.firStorageRef?.child(rutaStorage)
            if let uploadData = presciptionImage.image?.jpegData(compressionQuality: 1){
                let metadataStorage =  StorageMetadata()
                metadataStorage.contentType = "image/jpeg"
                storageRef?.putData(uploadData, metadata: metadataStorage, completion: { (metadata, error) in
                    if metadata != nil {
                        print("++++++++++++++++++++++++++", metadata?.path ?? "******************")
                        storageRef?.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print(error ?? "*****************")
                            } else {
                                downloadURL = (url?.absoluteString)!
                                print("---------------------", downloadURL)
                                Firebase.sharedInstance.prescription.sURLPrescription = downloadURL
                                Firebase.sharedInstance.addPrescription()
                                self.delegate?.addPrescriptionViewController(self, didEditPrescription: Firebase.sharedInstance.prescription)
                            }
                        })
                    } else {
                        print("**************************", error.debugDescription)
                    }
                })
            }
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
            view.configureContent(title: "Warning", body: "Pulsa Ok para volver a la lista de recetas (No se guardaran los datos)", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Ok", buttonTapHandler: { (button) in
                self.navigationController?.popViewController(animated: true)
            })
            //view.configureContent(title: "Warning", body: "Volviste atrás", iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    
    func addPrescriptionViewControllerDesign() {
        self.view.setGradientBackground()
        gmailsPicker.isHidden = true
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                gmail.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                gmail.addGestureRecognizer(tapUILabelName)
                presciptionImage.image = UIImage(named: "AddImagePrescription")
                presciptionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickUIImagePrescription)))
                presciptionImage.isUserInteractionEnabled = true
            case .patient:
                gmail.isUserInteractionEnabled = true
                let tapUILabelName = UITapGestureRecognizer(target: self, action: #selector(clickUILabelName(_:)))
                gmail.addGestureRecognizer(tapUILabelName)
                presciptionImage.image = UIImage(named: "AddImagePrescription")
                presciptionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickUIImagePrescription)))
                presciptionImage.isUserInteractionEnabled = true
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

extension AddPrescriptionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

