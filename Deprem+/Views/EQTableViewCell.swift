//
//  EQTableViewCell.swift
//  Deprem+
//
//  Created by Hakan Koşanoğlu on 6.07.2020.
//  Copyright © 2020 com.kai. All rights reserved.
//

import UIKit

class EQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static var identifier: String{
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
