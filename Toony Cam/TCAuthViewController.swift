//
//  TCAuthViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/30/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import TwitterKit

class TCAuthViewController: UIViewController {
    
    /*
     // MARK: - IMPORTANT
     */
    /// IMPORTANT
    // TODO: Future refactor needed. extract each completion block for each Firebase call back
    // to a modulirized clousure like so. Pay attention to dependencies due to there are some
    // values needed that will not be available in the clousure's scope. This is a foundation
    // start point. Needs fix for "out of scope" dependencies.
    
    //    var clousure = { (user:FIRUser?, error1:Error?) -> Void in
    //
    //    }
    
    //    var clousure = { (user:FIRUser?, error1:Error?) -> Void in
    //
    //        if user != nil && error1 == nil{
    //            userObj["id"] = user!.uid
    //            self.userCreateAccountProfile(forUser: user!, withUserObject: userObj)
    //        }else{
    //
    //        }
    //        
    //    }

    var isDisplayingPanel = false
    var isAnimatingPanel = false
    
    @IBOutlet weak var optionsPanel: TCAuthOptionsPanel!
    @IBOutlet weak var credentialsPanel: TCAuthCredentialsPanel!
	
	@IBOutlet weak var createButton: TCAuthButton!
	@IBOutlet weak var loginButton: TCAuthButton!
	@IBOutlet weak var noAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        optionsPanel.delegate = self
        credentialsPanel.delegate = self
        
        optionsPanel.resetPanel()
        credentialsPanel.resetPanel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willShowKeyboard(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willHideKeyboard(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchedView = touches.first!.view!
        
        switch touchedView.tag {
        case 3:
            print("\n TCAuthViewController --> Create")
            optionsPanel.resetPanel()
            //let panelName:String = optionsPanel.title!.text!.replacingOccurrences(of: "Login", with: "Create")
            //optionsPanel.title.text = panelName
            optionsPanel.authState = "Create"
            credentialsPanel.authState = "Create"
            credentialsPanel.authenticateButton.setTitle("Create", for: .normal)
            credentialsPanel.usernameTextField.isHidden = false
            credentialsPanel.confirmTextField.isHidden = false
			
			createButton.isEnabled = false
			loginButton.isEnabled = false
			noAccountButton.isEnabled = false
			
            optionsPanel.animatePanel(panelId: optionsPanel.tag, direction: .up)
            break
        case 5:
            print("\n TCAuthViewController --> Login")
            optionsPanel.resetPanel()
			
            optionsPanel.authState = "Login"
            credentialsPanel.authState = "Login"
            credentialsPanel.authenticateButton.setTitle("Login", for: .normal)
            credentialsPanel.usernameTextField.isHidden = true
            credentialsPanel.confirmTextField.isHidden = true
			
			createButton.isEnabled = false
			loginButton.isEnabled = false
			noAccountButton.isEnabled = false
            
            optionsPanel.animatePanel(panelId: optionsPanel.tag, direction: .up)
            break
			
		case 13:
			
			optionsPanel.title.text = "Authenticating..."
//			credentialsPanel.isUserInteractionEnabled = false
			self.view.isUserInteractionEnabled = false
			self.facebookSignin()
			
			break
			
		case 14:
			
			optionsPanel.title.text = "Authenticating..."
//			credentialsPanel.isUserInteractionEnabled = false
			self.view.isUserInteractionEnabled = false
			self.twitterSignIn()
			
			break
			
        case 28:
			
			self.view.endEditing(true)
            credentialsPanel.authenticateButton.isHidden = true
            credentialsPanel.loader.startAnimating()
//            credentialsPanel.isUserInteractionEnabled = false
			self.view.isUserInteractionEnabled = false
			
            if touchedView.isKind(of:TCAuthCredentialsButton.self) {
                
                print("\n touchedView is TCAuthCredentialsButton --> Authenticating")
                
                if credentialsPanel.authState == "Create" {
                    optionsPanel.authState = "Authenticating"
                    credentialsPanel.authState = "Authenticating"
                    credentialsPanel.title.text = "Authenticating..."
                    print("\n userCreateAccount() --> Authenticating")
                    userCreateAccount()
                }
                
                if credentialsPanel.authState == "Login" {
                    optionsPanel.authState = "Authenticating"
                    credentialsPanel.authState = "Authenticating"
                    credentialsPanel.title.text = "Authenticating..."
                    print("\n userLogin() --> Authenticating")
                    userLogin()
                }
            }
            
            break
            
        default:
            print("\n TCAuthViewController --> Touched View Tag: \(touchedView.tag)")
            //fatalError("THIS DEFAULT CASE MUST NEVER BE REACHED...")
            self.view.endEditing(true)
            break
        }
    }
	
	func facebookSignin() -> Void {
		
		let permissions = [
			"email",
			"public_profile"
		]
		
		let actionHandler:(_ action:UIAlertAction)-> Void = { (action)->Void in
			self.view.isUserInteractionEnabled = true
		}
		
		let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: actionHandler)
		alert.addAction(alertAction)
		
		FBSDKLoginManager().logIn(withReadPermissions: permissions, from: self) {(result, error1) in
			
			if let err1 = error1 {
				
				alert.title =  "Facebook Login Error 1:\nFacebook"
				alert.message = err1.localizedDescription
				
				self.present(alert, animated: true) { () -> Void in
					self.optionsPanel.title.text = "Account Options"
					self.optionsPanel.facebookButtonSpinner.stopAnimating()
					self.optionsPanel.facebookButton.setTitle("Facebook", for: .normal)
				}
				return
			}
			
			if result!.isCancelled {
				self.optionsPanel.title.text = "Account Options"
				self.optionsPanel.facebookButtonSpinner.stopAnimating()
				self.optionsPanel.facebookButton.setTitle("Facebook", for: .normal)
				self.view.isUserInteractionEnabled = true
				return
			}
			
			let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
			
			var updatedChilds:[String:String] = [:]
			
			FIRAuth.auth()?.signIn(with: credential) { (user, error2) in
				
				if let err2 = error2 {
					
					alert.title = "Facebook Login Error 2:\nFirebase login with Facebook"
					alert.message = err2.localizedDescription
					
					self.present(alert, animated: true) { () -> Void in
						self.optionsPanel.title.text = "Account Options"
						self.optionsPanel.facebookButtonSpinner.stopAnimating()
						self.optionsPanel.facebookButton.setTitle("Facebook", for: .normal)
					}
					return
				}
				
				guard let cUsr = user else {
					fatalError("This stage must never be reached!!!")
				}
				
				updatedChilds["email"] = cUsr.email
				updatedChilds["name"] = cUsr.displayName
				updatedChilds["provider"] = cUsr.providerData.first!.providerID
				updatedChilds["imageUrl"] = cUsr.providerData.first!.photoURL!.absoluteString
				
				print(cUsr.providerData)
				print(cUsr.providerData.count)
				print(cUsr.providerData.first!.providerID)
				print(cUsr.providerData.first!.photoURL!.absoluteString)
				
				let ref = FIRDatabase.database().reference().child("users").child(user!.uid)
				ref.updateChildValues(updatedChilds) { (error3, ref) in
					
					if let err3 = error3 {
						
						alert.title = "Facebook Login Error 3:\nDatabase"
						alert.message = err3.localizedDescription
						
						self.present(alert, animated: true) { () -> Void in
							self.optionsPanel.title.text = "Account Options"
							self.optionsPanel.facebookButtonSpinner.stopAnimating()
							self.optionsPanel.facebookButton.setTitle("Facebook", for: .normal)
						}
						return
					}
					
					self.optionsPanel.title.text = "Account Options"
					self.optionsPanel.authState = "Authenticated"
					self.optionsPanel.facebookButtonSpinner.stopAnimating()
					self.optionsPanel.facebookButton.setTitle("Facebook", for: .normal)
					
					self.optionsPanel.animatePanel(panelId: self.optionsPanel.tag, direction: .down)
				}
			}
		}
	}
	
	func twitterSignIn() {
		
		let actionHandler:(_ action:UIAlertAction)-> Void = { (action)->Void in
			self.view.isUserInteractionEnabled = true
		}
		
		let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: actionHandler)
		alert.addAction(alertAction)
		
		Twitter.sharedInstance().logIn { session, error1 in
			
			if let err1 = error1 {
				
				alert.title =  "Twitter Login Error 1:\nTwitter"
				alert.message = err1.localizedDescription
				
				self.present(alert, animated: true) { () -> Void in
					self.optionsPanel.title.text = "Account Options"
					self.optionsPanel.twitterButtonSpinner.stopAnimating()
					self.optionsPanel.twitterButton.setTitle("Twitter", for: .normal)
				}
				return
			}
			
			guard let sess = session else {
				fatalError("This stage must never be reached!!!")
			}
			
			let credential = FIRTwitterAuthProvider.credential(withToken: sess.authToken, secret: sess.authTokenSecret)
			
			FIRAuth.auth()?.signIn(with: credential) { (user, error2) in
				
				if let err2 = error2 {
					
					alert.title =  "Twitter Login Error 2:\nFirebase Login with Twitter"
					alert.message = err2.localizedDescription
					
					self.present(alert, animated: true) { () -> Void in
						self.optionsPanel.title.text = "Account Options"
						self.optionsPanel.twitterButtonSpinner.stopAnimating()
						self.optionsPanel.twitterButton.setTitle("Twitter", for: .normal)
					}
					return
				}
				
				guard let cUsr = user else {
					fatalError("This stage must never be reached!!!")
				}
				
				var updatedChilds:[String:String] = [:]
				
				updatedChilds["username"] = sess.userName
				updatedChilds["name"] = cUsr.displayName
				updatedChilds["provider"] = cUsr.providerData.first!.providerID
				updatedChilds["imageUrl"] = cUsr.providerData.first!.photoURL!.absoluteString
				
				let ref = FIRDatabase.database().reference().child("users").child(user!.uid)
				ref.updateChildValues(updatedChilds) { (error3, ref) in
					
					if let err3 = error3 {
						
						alert.title =  "Twitter Login Error 3:\nCreating Database Profile"
						alert.message = err3.localizedDescription
						
						self.present(alert, animated: true) { () -> Void in
							self.optionsPanel.title.text = "Account Options"
							self.optionsPanel.twitterButtonSpinner.stopAnimating()
							self.optionsPanel.twitterButton.setTitle("Twitter", for: .normal)
						}
						return
					}
					
					self.optionsPanel.title.text = "Account Options"
					self.optionsPanel.authState = "Authenticated"
					self.optionsPanel.twitterButtonSpinner.stopAnimating()
					self.optionsPanel.twitterButton.setTitle("Twitter", for: .normal)
					
					self.optionsPanel.animatePanel(panelId: self.optionsPanel.tag, direction: .down)
				}
			}
		}
	}

	
    func userLogin() -> Void {
        
        var userObj = [
			"email": credentialsPanel.emailTextField.text!,
			"pwd": credentialsPanel.passwordTextField.text!
		]
		
		let actionHandler:(_ action:UIAlertAction)-> Void = { (action)->Void in
			self.view.isUserInteractionEnabled = true
		}
		
		let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: actionHandler)
		alert.addAction(alertAction)
        
        FIRAuth.auth()?.signIn(withEmail: userObj["email"]!, password: userObj["pwd"]!) { (user, error) in
            
            if let err = error {
				
				alert.title =  "Error while loggin in with password..."
				alert.message = err.localizedDescription
				
				self.present(alert, animated: true) { () -> Void in
					self.optionsPanel.authState = "Login"
					self.credentialsPanel.authState = "Login"
					self.credentialsPanel.title.text = "Credentials"
					self.credentialsPanel.authenticateButton.isHidden = false
					self.credentialsPanel.loader.stopAnimating()
				}
				return
			}
			
			// Restoring Auth button
			self.credentialsPanel.authenticateButton.isHidden = false
			self.credentialsPanel.loader.stopAnimating()
			
			if FIRAuth.auth()?.currentUser == nil {
				
				alert.title =  "Login Error on getting user's auth data..."
				alert.message = "The system has encounter an error. Please report the bug..."
				
				self.present(alert, animated: true) { () -> Void in
					self.optionsPanel.authState = "Login"
					self.credentialsPanel.authState = "Login"
					self.credentialsPanel.title.text = "Credentials"
					self.credentialsPanel.authenticateButton.isHidden = false
					self.credentialsPanel.loader.stopAnimating()
				}
				return
			}
			
			self.dismiss(animated: true) {
				
				print("\n APPLICATION STATE LOG \n" +
					"At this point. User has successfully logged in to his account." +
					"We are traveling now back to the Camera module to have user's favorites filters already " +
					"loaded and diplaying on screen.")
			}
        }
    }
    
    func userCreateAccount() -> Void {
        
        var userObj = [
            "username":credentialsPanel.usernameTextField.text!,
            "email":credentialsPanel.emailTextField.text!,
            "pwd":credentialsPanel.passwordTextField.text!,
            "provider":"",
            "id":""
        ]
		
		let actionHandler:(_ action:UIAlertAction)-> Void = { (action)->Void in
			self.view.isUserInteractionEnabled = true
		}
		
		let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: actionHandler)
		alert.addAction(alertAction)
		
        self.credentialsPanel.title.text = "Creating account..."

        FIRAuth.auth()?.createUser(withEmail: userObj["email"]!, password: userObj["pwd"]!) { (user, error) in
            
            if let err = error {
				
				alert.title =  "Error while creating account with password..."
				alert.message = err.localizedDescription
				
				self.present(alert, animated: true) { () -> Void in
					self.optionsPanel.authState = "Create"
					self.credentialsPanel.authState = "Create"
					self.credentialsPanel.title.text = "Credentials"
					self.credentialsPanel.authenticateButton.isHidden = false
					self.credentialsPanel.loader.stopAnimating()
				}
				return
			}
			
			guard let cUsr = user else {
				fatalError("This stage must never be reached!!!")
			}
			
			userObj["id"] = cUsr.uid
			userObj["provider"] = cUsr.providerData.first!.providerID
			
			let changeRequest = cUsr.profileChangeRequest()
			
			changeRequest.displayName = userObj["username"]!
			changeRequest.commitChanges { error2 in
				
				if let err2 = error2 {
					
					// An error happened.
					alert.title =  "Error while updating user's created profile..."
					alert.message = err2.localizedDescription
					
					self.present(alert, animated: true) { () -> Void in
						self.optionsPanel.authState = "Create"
						self.credentialsPanel.authState = "Create"
						self.credentialsPanel.title.text = "Credentials"
						self.credentialsPanel.authenticateButton.isHidden = false
						self.credentialsPanel.loader.stopAnimating()
					}
					return
				}
				
				// Profile updated.
				self.credentialsPanel.title.text = "Creating profile..."
				let userRef = FIRDatabase.database().reference().child("users").child(userObj["id"]!)
				userRef.setValue(userObj) { (error3, ref) in
					
					if let err3 = error3 {
						
						// An error happened.
						alert.title =  "Error while Setting things up database..."
						alert.message = err3.localizedDescription
						
						self.present(alert, animated: true) { () -> Void in
							self.optionsPanel.authState = "Create"
							self.credentialsPanel.authState = "Create"
							self.credentialsPanel.title.text = "Credentials"
							self.credentialsPanel.authenticateButton.isHidden = false
							self.credentialsPanel.loader.stopAnimating()
						}
						return
					}
					
					// Account and all it's componets fully created.
					self.credentialsPanel.title.text = "Account Created..."
					self.credentialsPanel.authenticateButton.isHidden = false
					self.credentialsPanel.loader.stopAnimating()
					self.credentialsPanel.animatePanel(panelId: self.credentialsPanel.tag, direction: .down)
					
					// Double checking locally for current user.
					if FIRAuth.auth()?.currentUser == nil {
						
						alert.title =  "Create: Error on getting user's auth data..."
						alert.message = "The system has encaouterd an error. Please report the bug..."
						
						self.present(alert, animated: true) { () -> Void in
//							self.credentialsPanel.authenticateButton.isHidden = false
//							self.credentialsPanel.loader.stopAnimating()
						}
						return
					}
					
					self.dismiss(animated: true) {
						
						print("\n APPLICATION STATE LOG \n" +
							"At this point. User has successfully created his account." +
							"We are traveling now back to the Camera module to give users their favorites filters alreay " +
							"loaded and diplaying on screen.")
						
					}
				}
			}
        }
    }
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        optionsPanel.animatePanel(panelId: optionsPanel.tag, direction: .down)
        credentialsPanel.animatePanel(panelId: credentialsPanel.tag, direction: .down)
        
        optionsPanel.resetPanel()
        credentialsPanel.resetPanel()
        
    }
}

extension TCAuthViewController: TCAuthPanelDelegate {
    
    func willShowKeyboard(notification: NSNotification) {
        
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.credentialsPanel.delegate.willShowKeyboardForCredentials(authState: self.credentialsPanel.authState!)
            self.credentialsPanel.delegate.didStartAnimatingPanel(panelId: 20)
            if self.credentialsPanel.controlPanelMover.constant == 0 {
                
                UIView.animate(withDuration: 0.75,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 0.8,
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: {
                                
                                self.credentialsPanel.controlPanelMover.constant = -110
                                self.view.layoutIfNeeded()
                                
                }) { (check) in
                    
                    self.credentialsPanel.delegate.didFinishAnimatingPanel(panelId: 20)
                    
                }
            }
        }
    }
    
    func willHideKeyboard(notification: NSNotification) {
        
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.credentialsPanel.delegate.willHideKeyboardForCredentials(authState: self.credentialsPanel.authState!)
            self.credentialsPanel.delegate.didStartAnimatingPanel(panelId: 20)
            if self.credentialsPanel.controlPanelMover.constant != 0 {
                UIView.animate(withDuration: 0.75,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 0.8,
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: {
                                
                                self.credentialsPanel.controlPanelMover.constant = 0
                                self.view.layoutIfNeeded()
                                
                }) { (check) in
                    
                    self.credentialsPanel.delegate.didFinishAnimatingPanel(panelId: 20)
                    
                }
            }
        }
    }
    
    func travelingToPanel(panelId: Int) {
        
        switch panelId {
        case 10:
            
            print("\n TCAuthViewController --> Showing panel 10")
            credentialsPanel.animatePanel(panelId: 20, direction: .right)
            optionsPanel.animatePanel(panelId: 10, direction: .center)
            break
        case 20:
			
            print("\n TCAuthViewController --> Showing panel 20")
            optionsPanel.animatePanel(panelId: 10, direction: .left)
            credentialsPanel.animatePanel(panelId: 20, direction: .center)
            break
        default:
            break
        }
    }
    
    func willShowKeyboardForCredentials(authState: String) {
        print("\n TCAuthViewController --> willShowKeyboardForCredentials --> for state\(authState)")
    }
    
    func willHideKeyboardForCredentials(authState: String) {
        print("\n TCAuthViewController --> willHideKeyboardForCredentials --> for state\(authState)")
    }
    
    func didStartAnimatingPanel(panelId:Int) {
        print("\n TCAuthViewController --> Animations STARTED for panel with ID: \(panelId)")
    }

    func didFinishAnimatingPanel(panelId:Int) {
        print("\n TCAuthViewController --> Animations FINISHED for panel with ID: \(panelId)")
		
//		let idTest = panelId == 20 || panelId == 10
		
		if (optionsPanel.authState == "Canceling..." || credentialsPanel.authState == "Canceling..."){
			createButton.isEnabled = true
			loginButton.isEnabled = true
			noAccountButton.isEnabled = true
		}
		
		if (optionsPanel.authState == "Authenticated" || credentialsPanel.authState == "Authenticated"){
			
			self.dismiss(animated: true)
			
		}
    }
}
