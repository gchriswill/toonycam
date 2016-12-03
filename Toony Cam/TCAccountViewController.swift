//
//  TCAccountViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/5/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit
import FirebaseAuth

class TCAccountViewController: UIViewController {
	
	enum AccountProvider: String {
		case facebook = "facebook.com"
		case twitter = "twitter.com"
		case firebase = "password"
		
		static public func colorForProvider(id:String) -> UIColor {
			
			var aColor: UIColor?
			
			switch id {
			case AccountProvider.facebook.rawValue:
				aColor = #colorLiteral(red: 0.2935177684, green: 0.4324832559, blue: 0.6613974571, alpha: 1)
				break
			case AccountProvider.twitter.rawValue:
				aColor = #colorLiteral(red: 0.1295189559, green: 0.6997243762, blue: 0.9383151531, alpha: 1)
				break
			default:
				aColor = #colorLiteral(red: 0.868450582, green: 0.3705046773, blue: 0.2716209292, alpha: 1)
				break
			}
			
			return aColor!
		}
		
		static public func iconForProvider(id:String) -> UIImage {
			
			var aImage: UIImage?
			
			switch id {
			case AccountProvider.facebook.rawValue:
				aImage = #imageLiteral(resourceName: "ic_facebook_36pt")
				break
			case AccountProvider.twitter.rawValue:
				aImage = #imageLiteral(resourceName: "ic_twitter_36pt")
				break
			default:
				aImage = #imageLiteral(resourceName: "ic_firebase_36pt")
				break
			}
			
			return aImage!
		}
	}
	
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var email: UILabel!
	
	@IBOutlet weak var accountSocialStatus: UILabel!
	@IBOutlet weak var accountSocialButton: TCAccLinkButton!

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		if let currentUser = FIRAuth.auth()?.currentUser {
			
			// User is signed in.
			//ref = FIRDatabase.database().reference()
			let pId = currentUser.providerData.first?.providerID
			
			if let switcherFrom = currentUser.providerData.first?.photoURL?.absoluteString {
				
				let toSwitch = switcherFrom.replacingOccurrences(of: "_normal", with: "")
				let test1 = !toSwitch.contains("https")
				let caseTrue = URL(string: toSwitch.replacingOccurrences(of: "http", with: "https") )!
				let elseCase = URL(string: toSwitch)!
				let tcUrl = test1 ? caseTrue : elseCase
				
				do {
					let data = try Data(contentsOf: tcUrl)
					let aImage = UIImage(data: data)
					self.profileImage.image = aImage
					
				}catch{
					print(error)
					print(currentUser.photoURL!)
				}
			}
			
			self.profileImage.layer.cornerRadius = 50
			username.text = currentUser.displayName
			email.text = currentUser.email
			
			accountSocialStatus.text = "Logged in with \(pId!.replacingOccurrences(of: ".com", with: "") )"
			accountSocialStatus.textColor = AccountProvider.colorForProvider(id: pId!)
			accountSocialButton.setImage(AccountProvider.iconForProvider(id: pId!), for: UIControlState.normal)
			
		}
		
//		else {
//			// No user is signed in.
//			performSegue(withIdentifier: "FROM_CAM_TO_AUTH", sender: nil)
//			
//		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func helpAction(_ sender: UIBarButtonItem) {
		
		
		
	}

	@IBAction func settingsAction(_ sender: UIBarButtonItem) {
		
		
		
	}
	
	@IBAction func editAction(_ sender: UIButton) {
		
		
		
		
	}
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let button = sender as? UIBarButtonItem, button.tag == 4 {
            
            do{
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let button = sender as? UIBarButtonItem, button.tag == 2 {
            print("Canceling from ACC to return back to CAM")
            return true
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
