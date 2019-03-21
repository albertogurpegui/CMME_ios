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
        let identifier = "MeetingCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
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
        return Firebase.sharedInstance.arrMeeting.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MeetingCell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell", for: indexPath) as! MeetingCell
        let meeting = Firebase.sharedInstance.arrMeeting[indexPath.row]
        cell.meetingDoctor?.text = meeting.sNombreDoctorCompleto
        cell.meetingPatient?.text = meeting.sNombrePacienteCompleto
        cell.meetingDescription?.text = meeting.sDescripcionCita
        return cell
    }
    
    
}

extension MeetingViewController: AddMeetingViewControllerDelegate{
    func addMeetingViewController(_ vc: AddMeetingViewController, didEditMeeting meeting: Meeting) {
        navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
    }
    
    func errorAddMeetingViewController(_ vc: AddMeetingViewController) {
        vc.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
