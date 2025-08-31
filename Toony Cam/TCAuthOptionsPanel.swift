//
//  TCAuthOptionsControl.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/31/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit


class TCAuthOptionsPanel: TCAuthPanel {
	
	@IBOutlet weak var facebookButton: TCAuthOptionsButton!
	@IBOutlet weak var twitterButton: TCAuthOptionsButton!
	
	@IBOutlet weak var facebookButtonSpinner: UIActivityIndicatorView!
	@IBOutlet weak var twitterButtonSpinner: UIActivityIndicatorView!
	
    @IBAction func cancelAction(_ sender:UIButton){
		
		facebookButtonSpinner.stopAnimating()
		twitterButtonSpinner.stopAnimating()
		self.authState = "Canceling..."
		self.animatePanel(panelId: self.tag, direction: .down)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch touches.first!.view!.tag  {
        case 13:
            print("TCAuthOptionsPanel --> Facebook")
			
			twitterButtonSpinner.stopAnimating()
			twitterButton.setTitle("Twitter", for: .normal)
			
			facebookButton.setTitle("", for: .normal)
			facebookButtonSpinner.startAnimating()
			
			self.next?.touchesBegan(touches, with: event)
			
            break
        case 14:
            print("TCAuthOptionsPanel --> Twitter")
			
			facebookButtonSpinner.stopAnimating()
			facebookButton.setTitle("Facebook", for: .normal)
			
			twitterButton.setTitle("", for: .normal)
			twitterButtonSpinner.startAnimating()
			
			self.next?.touchesBegan(touches, with: event)
			
			break
        case 15:
            print("TCAuthOptionsPanel --> Username")
			
			facebookButtonSpinner.stopAnimating()
			twitterButtonSpinner.stopAnimating()
			
            self.delegate.travelingToPanel(panelId: 20)
            break
        default:
            print("TCAuthOptionsPanel --> Default")
            break
        }
    }
}

