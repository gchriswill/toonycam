//
//  TCAuthViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/30/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

class TCAuthViewController: UIViewController {

    var isDisplayingPanel = false
    var isAnimatingPanel = false
    
    @IBOutlet weak var optionsPanel: TCAuthOptionsPanel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        optionsPanel.resetOptionsPanel()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchedView = touches.first!.view!
        
        switch touchedView.tag {
        case 1:
            print("Create")
            optionsPanel.title.text = optionsPanel.title!.text!.replacingOccurrences(of: "Login", with: "Create")
            optionsPanel.animateOptionsPanel(direction: .up)
            
            break
        case 2:
            print("Login")
            optionsPanel.title.text = optionsPanel.title!.text!.replacingOccurrences(of: "Create", with: "Login")
            optionsPanel.animateOptionsPanel(direction: .up)
            break
        default:
            print("Touched View Tag --> \(touchedView.tag)")
            //fatalError("THIS DEFAULT CASE MUST NEVER BE REACHED...")
            break
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension TCAuthViewController: TCAuthPanelDelegate {
    
    func didStartanimatingOptionsPanel() {
        
    }

    func didFinishAnimatingOptionsPanel() {
        
    }
}
