//
//  ChoreCollectionViewCell.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit

class ChoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var choreDescription: UILabel!
    @IBOutlet weak var choreAmount: UILabel!
    
    @IBOutlet weak var choreImageView: UIImageView!
    @IBOutlet weak var speakerImage: CustomImageView!
}

class CustomImageView: UIImageView {
    var title = String()
}
