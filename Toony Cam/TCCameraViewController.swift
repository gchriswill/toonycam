//
//  TCCameraViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/24/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

//Firebase ROOT database location: https://toony-cam.firebaseio.com/

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TCCameraViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var canTakeShot = false
    var canTravel = false
    var isUiEnabled = false
    var isFirstLaunch = true
    
    @IBOutlet weak var camControlPanel: TCCamControlPanel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase'a root database object's location...
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            ref = FIRDatabase.database().reference()
        } else {
            // No user is signed in.
            performSegue(withIdentifier: "FROM_CAM_TO_AUTH", sender: nil)
        }
        
        print("\n FROM VIEW CON \n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TCCameraViewController: TCCamControlPanelDelegate {
    
    func didStartAnimatingPanelForActions() {
        canTakeShot = false
        canTravel = false
        isUiEnabled = false
    }
    
    func didFinishAnimatingPanelForAction(action: Int) {
        canTakeShot = true
        canTravel = true
        isUiEnabled = true
    }
    
    public func performCamAction(action:Int) {
        
        switch action {
        case 1:
            //Perform Segue to photo Library
            print("TRAVELING TO PHOTOS")
            break
        case 2:
            //Perfom take shot action
            //Perfom Segue to Preview Results
            print("TAKING SHOT EXECUTION")
            break
        case 3:
            print("TRAVELING TO FILTERS")
            //Perform Segue to filter library
            break
        default:
            fatalError("THIS DEFAULT CASE MUST NEVER BE REACHED")
            break
        }
    }
}
