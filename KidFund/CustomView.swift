//
//  CustomView.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    @IBInspectable var fillColor: UIColor = .blue
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Setup
    override func prepareForInterfaceBuilder() {
        setupView()
    }

    func setupView() {
        self.backgroundColor = color
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }

    // MARK: - Properties
    var color: UIColor = .white {
        didSet {
            self.backgroundColor = color
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    var shadowColor: UIColor = .black {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }

    var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }

    var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }

    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        super.draw(rect)
//
//        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: 10.0).cgPath
//
//        let ctx = UIGraphicsGetCurrentContext()!
//        ctx.addPath(clipPath)
//        fillColor.setFill()
////        ctx.setFillColor(UIColor.blue.cgColor)
//
//        ctx.closePath()
//        ctx.fillPath()
//    }
//
//
//}
