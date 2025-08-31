//
//  TCAuthCredentialsPanel.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/2/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

class TCAuthCredentialsPanel: TCAuthPanel {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var authenticateButton: TCAuthCredentialsButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
        
    @IBAction func backAction(_ sender:UIButton){
        print("\n TCAuthCredentialsPanel --> backing")
        self.superview?.endEditing(true)
        self.delegate.travelingToPanel(panelId: 10)
        
    }

    @IBAction func cancelAction(_ sender:UIButton){
        print("\n TCAuthCredentialsPanel --> Canceling")
        self.superview?.endEditing(true)
		self.authState = "Canceling..."
        self.animatePanel(panelId: self.tag, direction: .down)
		
        //TODO: Needs fix for cancel + keyboard animation bug...
        //self.superview?.endEditing(true)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func resetPanel() {
        controlPanelMover.constant = 0
        controlPanelSlider.constant = 600
        self.superview?.layoutIfNeeded()
    }
}

extension TCAuthCredentialsPanel {
    
    
}
