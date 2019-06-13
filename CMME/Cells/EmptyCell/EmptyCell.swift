//
//  EmptyCell.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 20/03/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var emptyText: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        emptyView?.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        emptyView?.layer.cornerRadius = 25
        emptyView?.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
