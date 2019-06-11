//
//  PrescriptionCell.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 09/06/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class PrescriptionCell: UITableViewCell {
    
    @IBOutlet weak var gmailDoctor: UILabel?
    @IBOutlet weak var gmailPaciente: UILabel?
    @IBOutlet weak var imagePrescription: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        gmailDoctor?.layer.cornerRadius = 8
        gmailDoctor?.layer.masksToBounds = true
        gmailDoctor?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        gmailDoctor?.layer.borderWidth = 1
        
        gmailPaciente?.layer.cornerRadius = 8
        gmailPaciente?.layer.masksToBounds = true
        gmailPaciente?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        gmailPaciente?.layer.borderWidth = 1
        
        imagePrescription?.layer.cornerRadius = 8
        imagePrescription?.layer.masksToBounds = true
        imagePrescription?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        imagePrescription?.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
