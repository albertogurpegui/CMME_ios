//
//  ContactCell.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 01/06/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var nameContact: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        nameContact?.layer.cornerRadius = 8
        nameContact?.layer.masksToBounds = true
        nameContact?.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        nameContact?.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
