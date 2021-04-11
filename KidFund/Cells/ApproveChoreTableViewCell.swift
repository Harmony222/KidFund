//
//  ApproveChoreTableViewCell.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/9/21.
//

import UIKit

class ApproveChoreTableViewCell: UITableViewCell {

    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var choreDescriptionLabel: UILabel!
    @IBOutlet weak var choreAmountLabel: UILabel!
    
    @IBOutlet weak var approvalButton: UIButton!
    @IBOutlet weak var denialButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
