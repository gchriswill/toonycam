//
//  TCAuthButton.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/30/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

@IBDesignable
class TCAuthButton: UIButton {
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let touchLocation = touches.first!.view!
        
        if !self.isAnimating {
            
            // TODO:
            // There is being performed lots of I/O due to of the construction of these animation
            // everytime the user preses the shot button. For beta release,
            // we will need to refactor and optimize this section...
            
            // NOTE: All animations and extra layers are being removed after the
            // animations had completed performing
            
            //Material Button Outter Animations
            let layerShadowRadius = CABasicAnimation(keyPath: "shadowRadius")
            layerShadowRadius.toValue = 4
            layerShadowRadius.duration = 0.3
            layerShadowRadius.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            self.layer.add(layerShadowRadius, forKey: "shadowRadius")
            
            // Material Button Inner Animations
            let effectlayer = CALayer()
            effectlayer.name = "materialButtonEffect"
            effectlayer.frame = CGRect(origin: CGPoint(x: self.layer.bounds.midX, y: self.layer.bounds.midY - (self.layer.bounds.height / 2) ), size: CGSize(width: 0, height: self.layer.bounds.height) )
            effectlayer.backgroundColor = UIColor.black.cgColor
            effectlayer.zPosition = -1
            effectlayer.opacity = 0.02
            
            let layerTouch = CABasicAnimation(keyPath: "bounds")
            layerTouch.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: (self.bounds.width), height: (self.bounds.height) ) )
            layerTouch.duration = 0.2
            layerTouch.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            layerTouch.delegate = self

            self.layer.addSublayer(effectlayer)
            effectlayer.add(layerTouch, forKey: "bounds")
            
            // Pasing the touch event to parent view "TCAuthViewController"
            self.next?.touchesBegan(touches, with: event)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension TCAuthButton: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        
        for lay in self.layer.sublayers! {
            
            if lay.name == "materialButtonEffect" {
                self.isAnimating = true
            }
        }
    }
    
    //Removing whatever's left. Just in case... LOL
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        for lay in self.layer.sublayers! {
            
            if lay.name == "materialButtonEffect" {
                lay.removeFromSuperlayer()
                self.isAnimating = false
            }
        }
    }
}
