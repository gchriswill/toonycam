//
//  TCPhotosCollectionViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/8/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit
import Photos
import FirebaseAuth
import FirebaseDatabase
import TwitterKit

private let reuseIdentifier = "TC_PHOTOS_CELL"

class TCPhotosCollectionViewController: UICollectionViewController {

	var databaseRef: FIRDatabaseReference! = nil
	
	var items: [UIImage] = []
	
	var traveling = false
	
	var cachedImage: UIImage!
	var assetCollection: PHAssetCollection!
	var albumFound : Bool = false
	var photosAsset: PHFetchResult<AnyObject>!
	var assetThumbnailSize:CGSize!
	var collection: PHAssetCollection!
	var assetCollectionPlaceholder: PHObjectPlaceholder!
	var selfieSource:[String] = [] {
		didSet{
			
			if items.count != selfieSource.count {
				
				for i in selfieSource.enumerated() {
					
					do {
						
						let iUrl = URL(string: i.element)
						let idata = try Data(contentsOf: iUrl!)
						print(i.offset)
						items += [UIImage(data: idata)!]
						self.collectionView!.reloadData()
					}catch{
						print(error.localizedDescription)
					}
				}
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(twShare), name: NSNotification.Name.init("SHARE"), object: nil)
		
		if let currentUser = FIRAuth.auth()?.currentUser {
			// User is signed in.
			databaseRef = FIRDatabase.database().reference()
			var mainLocation = "selfies"
			
			if self.title == "Favorites" {
					mainLocation = "favorites"
			}
			
			databaseRef.child(mainLocation).child(currentUser.uid).observe(FIRDataEventType.value, with: { (snapshot) in
				
				if snapshot.exists() {

					let values = snapshot.value as! Dictionary<String, String>
					
					var arr: [String] = []
					
					for i in values {
						arr += [i.value]
					}
					self.selfieSource = arr
				}
			})
			
		} else {
			
			// No user is signed in.
			let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
			let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
			
			alert.addAction(alertAction)
			
			alert.title = "You need to be signed to access this screen"
			alert.message = "Please sign in and return to this screen in order to access your fotos..."
			self.present(alert, animated: true, completion: nil)
			
		}
		
        //fatalError()
		//prepareAlbum()
		//showImages()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView?.isScrollEnabled = true
        
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		databaseRef.removeAllObservers()
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation
     // before navigation
     */
	
//	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//		
//		//return sender is TCPhotosCollectionViewCell ? false : true
//		
//	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
		
		print(sender!)
		
        if let vc_2 = segue.destination as? TCPreviewPhotoCollectionViewController {
            
            vc_2.useLayoutToLayoutNavigationTransitions = true
			
			traveling = true
            
		}else{
			traveling = false
		}
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TCPhotosCollectionViewCell
		
		cell.cellImage = items[indexPath.row]
        cell.isUserInteractionEnabled = true
        cell.shareButton.isHidden = true
        cell.shareButton.isEnabled = false
        
        return cell
        
    }
	
	func twShare(notification: Notification)-> Void{
		// Swift
		
		let imahge = notification.object as! UIImage
		let composer = TWTRComposer()
		
		composer.setText("Toony selfie from @toonycam")
		composer.setImage(imahge)
		
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
	
//	func prepareAlbum() {
//		//Get PHFetch Options
//		
//		let fetchOptions = PHFetchOptions()
//		fetchOptions.predicate = NSPredicate(format: "title = %@", "Toony Cam")
//		let collection : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//		//Check return value - If found, then get the first album out
//		if let _: AnyObject = collection.firstObject {
//			
//			self.albumFound = true
//			assetCollection = collection.firstObject! as PHAssetCollection
//			
//			self.showImages()
//			
//		} else {
//			
//			//If not found - Then create a new album
//			PHPhotoLibrary.shared().performChanges({
//				let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Toony Cam")
//				
//				self.assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
//			}, completionHandler: { success, error in
//				self.albumFound = success
//				
//				if (success) {
//					let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.assetCollectionPlaceholder.localIdentifier], options: nil)
//					
//					print(collectionFetchResult.count)
//					self.assetCollection = collectionFetchResult.firstObject! as PHAssetCollection
//					
//					self.showImages()
//					
//				}
//			})
//		}
//	}
	
	func showImages() {
		//This will fetch all the assets in the collection
		
		
		
//		let assets : PHFetchResult = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
//		print("Show Images Assets \(assets.count)")
//		
//		let imageManager = PHCachingImageManager()
//		//Enumerating objects to get a chached image - This is to save loading time
//		assets.enumerateObjects({(object: AnyObject!,
//			count: Int,
//			stop: UnsafeMutablePointer<ObjCBool>) in
//			
//			if object is PHAsset {
//				
//				let asset = object as! PHAsset
//				
//				print("Show assets type \(asset.mediaType)")
//				
//				let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
//				
//				let options = PHImageRequestOptions()
//				options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
//				options.isSynchronous = true
//				
//				imageManager.requestImage(for: asset,
//				                          targetSize: imageSize,
//				                          contentMode: PHImageContentMode.aspectFill,
//				                          options: options,
//				                          resultHandler: { (requestedImage, dictionary) in
//											
//											print(dictionary!)
////											print(requestedImage)
//											
//											if let img = requestedImage {
//												self.items += [img]
//												self.collectionView!.reloadData()
//											}
//				})
//
//			}
//		})
	}

}
