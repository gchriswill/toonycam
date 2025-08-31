//
//  TCAuthOptionsButton.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/31/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

@IBDesignable
class TCAuthOptionsButton: TCAuthButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchedView = touches.first!.view!
        
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
            effectlayer.backgroundColor = UIColor.white.cgColor
            effectlayer.zPosition = -1
            effectlayer.opacity = 0.075
            
            if touchedView.tag == 3 {
                effectlayer.backgroundColor = UIColor.black.cgColor
                effectlayer.opacity = 0.02
            }
            
            let layerTouch = CABasicAnimation(keyPath: "bounds")
            layerTouch.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: (self.bounds.width), height: (self.bounds.height) ) )
            layerTouch.duration = 0.2
            layerTouch.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            layerTouch.delegate = self
            
            self.layer.addSublayer(effectlayer)
            effectlayer.add(layerTouch, forKey: "bounds")
            
            // Pasing the touch event to parent view "TCAuthOptionsControlPanel"
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
