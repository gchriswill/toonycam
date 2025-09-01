//
//  AppDelegate.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/24/16.
//  Copyright (c) 2016-2025 Christopher W Gonzalez Melendez. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


	//	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
	//
	//		if let err = error {
	//			print("TTTTTTTT -> \(error.localizedDescription)")
	//
	//			let alert = UIAlertController(title: "Google Login Error 1",
	//			                              message: err.localizedDescription,
	//			                              preferredStyle: UIAlertControllerStyle.alert)
	//
	//			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil) )
	//
	//			window?.rootViewController?.present(alert, animated: true, completion: nil)
	//
	//			return
	//		}
	//
	//		let authentication = user.authentication
	//		print(signIn.currentUser.profile.name)
	//		print(signIn.currentUser.profile.givenName)
	//		print(signIn.currentUser.profile.familyName)
	//		print(signIn.currentUser.profile.email)
	//		let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
	//                                                    accessToken: (authentication?.accessToken)!)
	//
	//		FIRAuth.auth()?.signIn(with: credential) { (user, error) in
	//
	//			if let err = error {
	//
	//				let alert = UIAlertController(title: "Google Login Error 2",
	//				                              message: err.localizedDescription,
	//				                              preferredStyle: UIAlertControllerStyle.alert)
	//
	//				alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil) )
	//
	//				self.window?.rootViewController?.present(alert, animated: true, completion: nil)
	//			}else{
	//
	//			print(signIn.currentUser.profile.name)
	//			print(signIn.currentUser.profile.givenName)
	//			print(signIn.currentUser.profile.familyName)
	//			print(signIn.currentUser.profile.email)
	//
	//				self.window?.rootViewController?.performSegue(withIdentifier: "auth_segue", sender: self)
	//			}
	//		}
	//
	//	}
	
	//	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
	//		print(error)
	//	}
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		// FIRApp.configure()
		
		//		[[FBSDKApplicationDelegate sharedInstance] application:application
		//			didFinishLaunchingWithOptions:launchOptions];
		
		// FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
		
		// Twitter.sharedInstance().start(withConsumerKey: "",
		//                                consumerSecret: "")
		//
		//		GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
		//		GIDSignIn.sharedInstance().delegate = self
		
		// Fabric.with([Twitter.self])
		return true
	}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
		// FBSDKAppEvents.activateApp()
    }

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		
		
		//		if GIDSignIn.sharedInstance().handle(url,
		//		                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
		//		                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation]) {
		//
		//			return true
		//
		//		}
		
		// if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options) {
		// 	return true
		// }
		
		// if Twitter.sharedInstance().application(app, open:url, options: options) {
		// 	return true
		// }
		
		// If you handle other (non Twitter Kit) URLs elsewhere in your app, return true. Otherwise
		return true
	}
}

