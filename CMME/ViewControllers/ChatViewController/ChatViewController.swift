//
//  ChatViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 25/05/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

import UIKit
import MessageKit
import MessageInputBar

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrContacts:[Contact] = []
    
    
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        let childVC = MessageViewController()
        addChild(childVC)
        self.view.addSubview(childVC.view)
        childVC.didMove(toParent:self)
        self.becomeFirstResponder()
    }*/
    
    init(){
        super.init(nibName: "ChatViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.view.setGradientBackground()
        Firebase.sharedInstance.getContacts(completion: { (contacts) in
            self.arrContacts = contacts
            self.tableView.reloadData()
        })
    }
    
    internal func registerCell(){
        let identifier = "EmptyCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
        let identifier2 = "ContactCell"
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
                let addVC = AddContactViewController()
                addVC.delegate = self
                addVC.modalTransitionStyle = .coverVertical
                addVC.modalPresentationStyle = .overCurrentContext
                navigationController?.pushViewController(addVC, animated: true)
            //present(addVC,animated: true,completion: nil)
            case .patient:
                let addVC = AddContactViewController()
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
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Firebase.sharedInstance.arrContacts.count == 0 {
            return 1
        }else {
            return Firebase.sharedInstance.arrContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Firebase.sharedInstance.arrContacts.count == 0 {
            return 95.0
        }else {
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Firebase.sharedInstance.arrContacts.count == 0 {
            let cell: EmptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            if let typeUser = ContainerNavigationController.userType {
                switch typeUser {
                case .doctor:
                    cell.emptyText?.text = "No tienes contactos con quien puedas hablar, pincha en el boton '+' para añadir uno"
                case .patient:
                    cell.emptyText?.text = "No tienes contactos con quien puedas hablar"
                }
            }
            return cell
        }else {
            let cell: ContactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            let contact = Firebase.sharedInstance.arrContacts[indexPath.row]
            cell.nameContact?.text = contact.sGmailContacto
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            Firebase.sharedInstance.arrContacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
        }
    }
}

extension ChatViewController: AddContactViewControllerDelegate {
    func addContactViewController(_ vc: AddContactViewController, didEditContact contact: Contact) {
        navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
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
    
    func errorAddContactViewController(_ vc: AddContactViewController) {
        vc.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
