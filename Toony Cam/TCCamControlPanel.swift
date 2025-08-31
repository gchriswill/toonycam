//
//  TCControlView.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/29/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

@objc public protocol TCCamControlPanelDelegate {
    func didStartAnimatingPanelForActions()
    func didFinishAnimatingPanelForAction(action:Int)
    func performCamAction(action:Int)
}

class TCCamControlPanel: UIView {

    var isAnimating = false
    var currentAction = -1
    
    @IBOutlet weak var delegate:TCCamControlPanelDelegate!
    @IBOutlet weak var photoLibrary: TCCamButton!
    @IBOutlet weak var camShotButton: TCCamShotButton!
    @IBOutlet weak var filterLibrary: TCCamButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !isAnimating {
            
            // TODO:
            // There is being performed lots of I/O due to of the construction of these animation
            // everytime the user preses the shot button. For beta release,
            // we will need to refactor and optimize this section...
            
            // NOTE: All animations and extra layers are being removed after the
            // animations had completed performing
            
            // Material Card Inner Animations
            let touchedView = touches.first!.view!
            
            if touchedView.tag != 0 {
                
                currentAction = touchedView.tag
                
                let effectlayer = CALayer()
                effectlayer.name = "materialCardEffectBlack"
                effectlayer.frame = CGRect(origin: CGPoint(x: touchedView.center.x, y: touchedView.center.y), size: CGSize())
                effectlayer.backgroundColor = UIColor.black.cgColor
                effectlayer.zPosition = -1
                effectlayer.opacity = 0.05
                
                let layerTouch = CABasicAnimation(keyPath: "bounds")
                layerTouch.toValue = NSValue(cgRect: CGRect(origin: CGPoint(), size: CGSize(width: (self.bounds.width * 2), height: (self.bounds.width * 2) ) ) )
                layerTouch.duration = 0.75
                layerTouch.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                layerTouch.delegate = self
                
                let layerRound = CABasicAnimation(keyPath: "cornerRadius")
                layerRound.toValue = self.bounds.width
                layerRound.duration = 0.75
                layerRound.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                self.layer.addSublayer(effectlayer)
                effectlayer.add(layerTouch, forKey: "bounds")
                effectlayer.add(layerRound, forKey: "cornerRadius")
                
            }
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

extension TCCamControlPanel: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        
        for lay in self.layer.sublayers! {
            
            if lay.name == "materialCardEffectBlack" {
                self.isAnimating = true
                
                delegate.didStartAnimatingPanelForActions()
            }
        }
    }
    
    // For removing the layer that was added for the material card animation
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        for lay in self.layer.sublayers! {
            
            if lay.name == "materialCardEffectBlack" {
                lay.removeFromSuperlayer()
                self.isAnimating = false
                
                delegate.didFinishAnimatingPanelForAction(action: currentAction)
                delegate.performCamAction(action: currentAction)
            }
        }
    }
}
