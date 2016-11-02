//
//  TCAuthOptionsControl.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/31/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

@IBDesignable
class TCAuthOptionsPanel: TCAuthPanel {
    
    @IBOutlet weak var title: UILabel!
    
    @IBAction func cancelAction(_ sender:UIButton){
        animateOptionsPanel(direction: .down)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first!.view!.tag == 11 {
            print("TCAuthOptionsPanel --> Facebook")
            
        }
        
        if touches.first!.view!.tag == 12 {
            print("TCAuthOptionsPanel --> Google+")
            
        }

        if touches.first!.view!.tag == 13 {
            print("TCAuthOptionsPanel --> Username")
            animateOptionsPanel(direction: .left)
        }
    }
}

