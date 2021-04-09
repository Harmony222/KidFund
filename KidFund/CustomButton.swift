//
//  CustomButton.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    @IBInspectable var fillColor: UIColor = .blue
    @IBInspectable var isParentButton: Bool = true
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)

        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: 10.0).cgPath

        let ctx = UIGraphicsGetCurrentContext()!
        ctx.addPath(clipPath)
        fillColor.setFill()
//        ctx.setFillColor(UIColor.blue.cgColor)

        ctx.closePath()
        ctx.fillPath()

    }
}
