//
//  MeetingCell.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 05/03/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {
    
    @IBOutlet weak var meetingDoctor: UILabel?
    @IBOutlet weak var meetingPatient: UILabel?
    @IBOutlet weak var meetingDescription: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
