//
//  TCPhotosNavigationController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/8/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

class TCPhotosNavigationController: UINavigationController {
	
	override var shouldAutorotate: Bool {
		return false
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
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
