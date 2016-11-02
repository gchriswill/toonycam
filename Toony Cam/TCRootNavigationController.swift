//
//  TCRootNavigationController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/28/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

class TCRootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Navigation bar - Make iT Transparent? LOL
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        // Ok, revert it then...
//        self.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
//        self.navigationBar.shadowImage = nil
//        self.navigationBar.tintColor = nil
//        self.navigationBar.isTranslucent = false
        
        print("\n FROM NAV CON \n")
        
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
