//
//  TCAccLinkButton.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/6/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

@IBDesignable
class TCAccLinkButton: UIButton {
    
    var isAnimating = false
    
    @IBInspectable var tcRadius:CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = self.tcRadius
        }
    }
    
    @IBInspectable var tcShadowRadius:CGFloat = 0 {
        didSet{
            self.layer.shadowRadius = self.tcShadowRadius
        }
    }
    
    @IBInspectable var tcShadowOpacity:CGFloat = 0 {
        didSet{
            self.layer.shadowOpacity = Float(self.tcShadowOpacity)
        }
    }
    
    @IBInspectable var tcShadowOffset:CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet{
            self.layer.shadowOffset = self.tcShadowOffset
        }
    }
    
    @IBInspectable var tcShadowColor:UIColor = UIColor.black {
        didSet{
            self.layer.shadowColor = self.tcShadowColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.defaultedMaterialButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.defaultedMaterialButton()
    }
    
    func defaultedMaterialButton() -> Void {
        self.layer.cornerRadius = self.tcRadius
        self.layer.shadowRadius = self.tcShadowRadius
        self.layer.shadowOpacity = Float(self.tcShadowOpacity)
        self.layer.shadowOffset = self.tcShadowOffset
        self.layer.shadowColor = self.tcShadowColor.cgColor
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
