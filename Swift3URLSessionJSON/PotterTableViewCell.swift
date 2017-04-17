//
//  PotterTableViewCell.swift
//  Swift3URLSessionJSON
//
//  Created by Matthew Singleton on 4/17/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class PotterTableViewCell: UITableViewCell {
  
  @IBOutlet weak var imgageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
