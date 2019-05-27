//
//  MeetingCell.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 05/03/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {
    
    @IBOutlet weak var meetingView: UIView?
    @IBOutlet weak var meetingDoctor: UILabel?
    @IBOutlet weak var meetingPatient: UILabel?
    @IBOutlet weak var meetingDescription: UILabel?
    @IBOutlet weak var meetingDate: UILabel?
    @IBOutlet weak var meetingConsultation: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        meetingView?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        meetingView?.layer.cornerRadius = 25
        meetingView?.layer.masksToBounds = true
        
        meetingDoctor?.layer.cornerRadius = 8
        meetingDoctor?.layer.masksToBounds = true
        meetingDoctor?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        meetingDoctor?.layer.borderWidth = 1
        
        meetingPatient?.layer.cornerRadius = 8
        meetingPatient?.layer.masksToBounds = true
        meetingPatient?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        meetingPatient?.layer.borderWidth = 1
        
        meetingDescription?.layer.cornerRadius = 8
        meetingDescription?.layer.masksToBounds = true
        meetingDescription?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        meetingDescription?.layer.borderWidth = 1
        
        meetingDate?.layer.cornerRadius = 8
        meetingDate?.layer.masksToBounds = true
        meetingDate?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        meetingDate?.layer.borderWidth = 1
        
        meetingConsultation?.layer.cornerRadius = 8
        meetingConsultation?.layer.masksToBounds = true
        meetingConsultation?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        meetingConsultation?.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
