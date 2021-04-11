//
//  GoalCollectionViewCell.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/9/21.
//

import UIKit

class GoalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var goalAmountLabel: UILabel!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var progressBarView: ProgressBar!
    
    @IBOutlet weak var speakerButton1: UIButton!
    @IBOutlet weak var speakerButton2: UIButton!
    @IBOutlet weak var editButton: UIButton!
}
