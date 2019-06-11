//
//  PrescriptionViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 26/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit
import SDWebImage

class PrescriptionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var arrPrescriptions:[Prescription] = []
    
    init(){
        super.init(nibName: "PrescriptionViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.view.setGradientBackground()
        Firebase.sharedInstance.getUserPrescriptions(completion: { (prescriptions) in
            self.arrPrescriptions = prescriptions
            self.tableView?.reloadData()
        })
    }
    
    internal func registerCell(){
        let identifier = "EmptyCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView?.register(cellNib, forCellReuseIdentifier: identifier)
        let identifier2 = "PrescriptionCell"
        let cellNib2 = UINib(nibName: identifier2, bundle: nil)
        tableView?.register(cellNib2, forCellReuseIdentifier: identifier2)
    }
    
    @objc internal func addPressed (){
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                let addVC = AddPrescriptionViewController()
                addVC.delegate = self
                addVC.modalTransitionStyle = .coverVertical
                addVC.modalPresentationStyle = .overCurrentContext
                navigationController?.pushViewController(addVC, animated: true)
            case .patient:
                let addVC = AddPrescriptionViewController()
                addVC.delegate = self
                addVC.modalTransitionStyle = .coverVertical
                addVC.modalPresentationStyle = .overCurrentContext
                navigationController?.pushViewController(addVC, animated: true)
            }
        }
    }
}

extension PrescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrPrescriptions.count == 0 {
            return 110.0
        }
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrPrescriptions.count == 0 {
            let cell: EmptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            if let typeUser = ContainerNavigationController.userType {
                switch typeUser {
                case .doctor:
                    cell.emptyText?.text = "No tienes recetas que puedas mandar a un paciente, pincha en el boton '+' \n para crear una receta"
                case .patient:
                    cell.emptyText?.text = "No hay recetas medicas que puedas ver, manda un mensaje a tu doctor para que te cree una"
                }
            }
            return cell
        }
        let cell: PrescriptionCell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell", for: indexPath) as! PrescriptionCell
        let prescription = arrPrescriptions[indexPath.row]
        print("*********************", prescription.sURLPrescription!)
        cell.imagePrescription?.sd_setImage(with: URL(string: prescription.sURLPrescription!), placeholderImage: UIImage(named: "Prescription"))
        cell.gmailDoctor?.text = prescription.sGmailDoctor
        cell.gmailPaciente?.text = prescription.sGmailPaciente
        return cell
    }
}

extension PrescriptionViewController: AddPrescriptionViewControllerDelegate {
    func addPrescriptionViewController(_ vc: AddPrescriptionViewController, didEditPrescription prescription: Prescription) {
        navigationController?.popViewController(animated: true)
        self.tableView?.reloadData()
        switch ContainerNavigationController.userType {
        case .doctor?:
            if let completeName =  Firebase.sharedInstance.doctor.sNombreCompleto{
                self.addNotificationContact(nameOfCreator: completeName)
            }
        case .patient?:
            if let completeName =  Firebase.sharedInstance.patient.sNombreCompleto{
                self.addNotificationContact(nameOfCreator: completeName)
            }
        case .none:
            break
        }
    }
    
    func errorAddPrescriptionViewController(_ vc: AddPrescriptionViewController) {
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
