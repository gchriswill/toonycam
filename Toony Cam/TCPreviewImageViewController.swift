//
//  TCPreviewImageViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 12/1/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import TwitterKit

class TCPreviewImageViewController: UIViewController {
	
	var storageRef: FIRStorageReference! = nil
	var databaseRef: FIRDatabaseReference! = nil
	
	@IBOutlet weak var previewImage: UIImageView!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	var cachedImage:UIImage! = nil
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		databaseRef = FIRDatabase.database().reference()
		storageRef = FIRStorage.storage().reference()
		previewImage.image = cachedImage
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func closeAction(_ sender: UIBarButtonItem) {
		
		self.dismiss(animated: true, completion: nil)
		
	}
	
	@IBAction func SaveAction(_ sender: UIBarButtonItem) {
		
//		let actionHandler:(_ action:UIAlertAction)-> Void = { (action)->Void in
//
//		}
		
		self.loadingIndicator.startAnimating()
		
		let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
		alert.addAction(alertAction)
		
		if let currentUser = FIRAuth.auth()?.currentUser {
		
			let formatter = DateFormatter()
			formatter.dateFormat = "YYYY-MM-dd_HH-mm-ss"
			let date = formatter.string(from: Date() )
			
			let upRef = self.storageRef.child("selfies").child(currentUser.uid).child(date)
			
			let imgData = UIImageJPEGRepresentation(cachedImage, 0.6)!
			
			upRef.put(imgData, metadata: nil) { (meta, error) in

				if let err = error {
					alert.title = "An error ocurred while uploading your picture..."
					alert.message = err.localizedDescription
					self.present(alert, animated: true, completion: nil)
					return
				}
				
				let dbRef = self.databaseRef.child("selfies").child(currentUser.uid)
				dbRef.updateChildValues([date: meta!.downloadURL()!.absoluteString ]) { (error2, ref) in
					
					if let err2 = error2 {
						alert.title = "An error ocurred while mapping your picture with Toony Cloud..."
						alert.message = err2.localizedDescription
						self.present(alert, animated: true, completion: nil)
						return
					}
					
					self.loadingIndicator.stopAnimating()
					
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
	
	@IBAction func shareAction(_ sender: UIButton) {
		
		
		let composer = TWTRComposer()
		
		composer.setText("Toony selfie from @toonycam")
		composer.setImage(previewImage.image)
		
		// Called from a UIViewController
		composer.show(from: self) { result in
			if (result == TWTRComposerResult.cancelled) {
				print("Tweet composition cancelled")
			}
			else {
				print("Sending tweet!")
			}
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
