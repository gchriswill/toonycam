//
//  TCImageShotButton.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/29/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

@IBDesignable
class TCCamShotButton: TCCamButton {
    
    @IBInspectable var tcRadius:CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = self.tcRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.tcRadius
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.cornerRadius = self.tcRadius
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !(self.superview as! TCCamControlPanel).isAnimating {
            
            // TODO:
            // There is being performed lots of I/O due to of the construction of these animation 
            // everytime the user preses the shot button. For beta release, 
            // we will need to refactor and optimize this section...
            
            // NOTE: All animations and extra layers are being removed after the 
            // animations had completed performing
            
            //Material Button Outter Animations
            let layerShadowOpacity = CABasicAnimation(keyPath: "shadowOpacity")
            layerShadowOpacity.toValue = 0.6
            layerShadowOpacity.duration = 0.4
            layerShadowOpacity.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let layerShadowRadius = CABasicAnimation(keyPath: "shadowRadius")
            layerShadowRadius.toValue = 6
            layerShadowRadius.duration = 0.4
            layerShadowRadius.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            self.layer.add(layerShadowOpacity, forKey: "shadowOpacity")
            self.layer.add(layerShadowRadius, forKey: "shadowRadius")
            
            // Material Button Inner Animations
            let effectlayer = CALayer()
            effectlayer.name = "materialButt    onEffectWhite"
            effectlayer.frame = CGRect(origin: CGPoint(x: self.layer.bounds.midX, y: self.layer.bounds.midY), size: CGSize())
            effectlayer.backgroundColor = UIColor.white.cgColor
            effectlayer.zPosition = -1
            effectlayer.opacity = 0.1
            
            let layerTouch = CABasicAnimation(keyPath: "bounds")
            layerTouch.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height) )
            layerTouch.duration = 0.4
            layerTouch.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            layerTouch.delegate = self
            
            let layerRound = CABasicAnimation(keyPath: "cornerRadius")
            layerRound.toValue = 48
            layerRound.duration = 0.4
            layerRound.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            self.layer.addSublayer(effectlayer)
            effectlayer.add(layerTouch, forKey: "bounds")
            effectlayer.add(layerRound, forKey: "cornerRadius")
            
            // Pasing the touch event to parent view "TCCamControlPanel"
            self.next?.touchesBegan(touches, with: event)
            
        }
    }
    
    // Default code completion by system
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     
     override func draw(_ rect: CGRect) {
     
     
     }
     */
}

extension TCCamShotButton: CAAnimationDelegate {
    
    //Removing whatever's left. Just in case... LOL
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        for lay in self.layer.sublayers! {
            
            if lay.name == "materialButtonEffectWhite" {
                lay.removeFromSuperlayer()
            }
        }
    }
}
