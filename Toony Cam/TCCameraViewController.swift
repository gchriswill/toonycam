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

class TCCameraViewController: UIViewController {
    
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Firebase'a root database object's location...
        ref = FIRDatabase.database().reference()
        
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
