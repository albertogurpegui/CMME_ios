//
//  MeetingViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 26/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class MeetingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrMeetings: [Meeting] = []
    
    
    init(){
        super.init(nibName: "MeetingViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.view.setGradientBackground()
        Firebase.sharedInstance.getUserMeetings(completion: { (meetings) in
            self.arrMeetings = meetings
            self.tableView.reloadData()
        })
    }
    
    internal func registerCell(){
        let identifier = "EmptyCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
        let identifier2 = "MeetingCell"
        let cellNib2 = UINib(nibName: identifier2, bundle: nil)
        tableView.register(cellNib2, forCellReuseIdentifier: identifier2)
    }
    
    internal func createButtonAdd(){
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    @objc internal func addPressed (){
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                let addVC = AddMeetingViewController()
                addVC.delegate = self
                addVC.modalTransitionStyle = .coverVertical
                addVC.modalPresentationStyle = .overCurrentContext
                navigationController?.pushViewController(addVC, animated: true)
                //present(addVC,animated: true,completion: nil)
            case .patient:
                let addVC = AddMeetingViewController()
                addVC.delegate = self
                addVC.modalTransitionStyle = .coverVertical
                addVC.modalPresentationStyle = .overCurrentContext
                navigationController?.pushViewController(addVC, animated: true)
                //present(addVC,animated: true,completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension MeetingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Firebase.sharedInstance.arrMeeting.count == 0 {
            return 1
        }else {
            return Firebase.sharedInstance.arrMeeting.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Firebase.sharedInstance.arrMeeting.count == 0 {
            return 95.0
        }else {
            return 220.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Firebase.sharedInstance.arrMeeting.count == 0 {
            let cell: EmptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            cell.emptyText?.text = "No hay citas medicas que puedas ver, pincha en el boton '+' para solicitar una cita"
            return cell
        }else {
            let cell: MeetingCell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell", for: indexPath) as! MeetingCell
            let meeting = Firebase.sharedInstance.arrMeeting[indexPath.row]
            cell.meetingDoctor?.text = meeting.sNombreDoctorCompleto
            cell.meetingPatient?.text = meeting.sNombrePacienteCompleto
            cell.meetingDescription?.text = meeting.sDescripcionCita
            cell.meetingConsultation?.text = meeting.sSalaCita
            cell.meetingDate?.text = meeting.sFechaCita
            return cell
        }
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            Firebase.sharedInstance.arrMeeting.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
        }
    }
}

extension MeetingViewController: AddMeetingViewControllerDelegate {
    func addMeetingViewController(_ vc: AddMeetingViewController, didEditMeeting meeting: Meeting) {
        navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
        switch ContainerNavigationController.userType {
        case .doctor?:
            if let completeName =  Firebase.sharedInstance.doctor.sNombreCompleto{
                self.addNotificationMeeting(nameOfCreator: completeName)
            }
        case .patient?:
            if let completeName =  Firebase.sharedInstance.patient.sNombreCompleto{
                self.addNotificationMeeting(nameOfCreator: completeName)
            }
        case .none:
            break
        }
    }
    
    func errorAddMeetingViewController(_ vc: AddMeetingViewController) {
        vc.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
