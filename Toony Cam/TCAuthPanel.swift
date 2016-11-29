//
//  TCAuthPanel.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/2/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

@objc public protocol TCAuthPanelDelegate {
    func travelingToPanel(panelId:Int)
    func didStartAnimatingPanel(panelId:Int)
    func didFinishAnimatingPanel(panelId:Int)
    
    //Specific to Credentials Panel
    func willShowKeyboardForCredentials(authState:String)
    func willHideKeyboardForCredentials(authState:String)
}

@IBDesignable
class TCAuthPanel: UIView {
    
    enum Direction:Int {
        case up = 0
        case down = 1
        case left = 2
        case right = 3
        case center = -1
    }
    
    var authState:String? = nil
    var isAnimating = false
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var controlPanelMover: NSLayoutConstraint!
    @IBOutlet weak var controlPanelSlider: NSLayoutConstraint!
    @IBOutlet var delegate: TCAuthPanelDelegate!
    
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
        self.defaultedMaterialPanel()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.defaultedMaterialPanel()
    }
    
    func defaultedMaterialPanel() -> Void {
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

extension TCAuthPanel {
    
    func animatePanel(panelId:Int, direction:Direction) {
        self.isAnimating = true
        self.delegate.didStartAnimatingPanel(panelId: panelId)
        
        UIView.animate(withDuration: 0.75,
                       delay: 0.4,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.8,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        
                        self.optionResolver(direction: direction)
                        self.superview?.layoutIfNeeded()
                        
        }) { (check) in
            
            self.isAnimating = false
            self.delegate.didFinishAnimatingPanel(panelId: panelId)

            if panelId == 20 && direction == .down {
                self.resetPanel()
            }
        }
    }
    
    private func optionResolver(direction:Direction){
        
        switch direction {
        case .up:
            
            self.controlPanelMover.constant = 0
            break
        case .down:
            
            self.controlPanelMover.constant = 600
            break
        case .left:
            
            self.controlPanelSlider.constant = -600
            break
        case .right:
            
            self.controlPanelSlider.constant = 600
            break
        default:
            self.controlPanelMover.constant = 0
            self.controlPanelSlider.constant = 0
            break
        }
    }
    
    internal func resetPanel() {
        self.controlPanelMover.constant = 600
        self.controlPanelSlider.constant = 0
        self.superview?.layoutIfNeeded()
    }
}


