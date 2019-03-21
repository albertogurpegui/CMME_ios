//
//  PrescriptionViewController.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 26/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class PrescriptionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        registerCell()
    }
    
    internal func registerCell(){
        let identifier = "EmptyCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView?.register(cellNib, forCellReuseIdentifier: identifier)
    }
    
    @objc internal func addPressed (){
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                print("Click add in prescription")
            case .patient:
                print("Click add in prescription")
            }
        }
    }
}

extension PrescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EmptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
        cell.emptyText?.text = "No hay recetas medicas que puedas ver, manda un mensaje a tu doctor para que te cree una"
        return cell
    }
}
