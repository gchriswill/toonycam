//
//  TCCameraViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 10/24/16.
//  Copyright (c) 2016-2025 Christopher W Gonzalez Melendez. All rights reserved.
//

//Firebase ROOT database location: https://toony-cam.firebaseio.com/

import UIKit
import FirebaseDatabase
import FirebaseAuth

import AVFoundation
import ImageIO
import Photos
import AssetsLibrary

class TCCameraViewController: UIViewController {
	
    var dbRef: FIRDatabaseReference!
	var storageRef: FIRStorageReference!
    var canTakeShot = false
    var canTravel = false
    var isUiEnabled = false
    var isFirstLaunch = true
	
	var filterSource: Array<String> = [] {
		didSet{
			
			if filterImages.count != filterSource.count {
				
				filterImages.removeAll()
				self.filterCollectionView.isScrollEnabled = false
				self.filterCollectionView.isUserInteractionEnabled = false
				
				var e = 0
				for i in filterSource.enumerated() {
					
					DispatchQueue.global().async {
					
						do {
							
							//self.filterCollectionView.deleteItems(at: self.filterCollectionView.visibleCells)
							
							let iUrl = URL(string: i.element)
							let idata = try Data(contentsOf: iUrl!)
							print(i.offset)
							
							self.filterImages += [UIImage(data: idata)!]
							
							DispatchQueue.main.async {
								self.filterCollectionView.reloadData()
								
								
								if e == self.filterSource.endIndex - 1 {
								
									self.filterCollectionView.isScrollEnabled = true
									self.filterCollectionView.isUserInteractionEnabled = true
								}
								
								e += 1
							}
							
							
						}catch{
							print(error.localizedDescription)
						}
					}
				}
			}
		}
	}
	
	var filterImages: Array<UIImage> = []
	var currentFilter:UIImage? = nil
	var currentIndexPath: IndexPath? = nil
	
	var cachedImage: UIImage!
	var assetCollection: PHAssetCollection!
	var albumFound : Bool = false
	var photosAsset: PHFetchResult<AnyObject>!
	var assetThumbnailSize:CGSize!
	var collection: PHAssetCollection!
	var assetCollectionPlaceholder: PHObjectPlaceholder!
    
    // MARK: Magic properties
    /// AVFoundation's APIs properties Area ------------->
    
    // The layer where the camera outputs is previewed
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // The layer of for one face filter
    var hostCALayer = CALayer()
	var faceCALayer = CALayer()
    
    // The session queue
    var sessionQueue: DispatchQueue = DispatchQueue(label: "videoQueue", attributes: [])
    
    //  AV's session properties
    var session: AVCaptureSession!
    var sessionConnection: AVCaptureConnection! // TODO: This property might not be needed...
    
    // Session's outputs objects
    var metadataOutput: AVCaptureMetadataOutput!
    var stillImageOutput:AVCaptureStillImageOutput!
    
    // Session's camera hardware in objects
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    /// -------------^
    
    @IBOutlet weak var camControlPanel: TCCamControlPanel!
	@IBOutlet weak var filterCollectionView: UICollectionView!
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		dbRef = FIRDatabase.database().reference()
		dbRef.child("filters").observe(FIRDataEventType.value, with: { (snapshot) in
			
			print(snapshot)
			
			if snapshot.exists() {
				self.filterSource = snapshot.value as! Array<String>
			}
			
		})
		
		// Firebase'a root database object's location...
		if FIRAuth.auth()?.currentUser != nil {
			// User is signed in.
			storageRef = FIRStorage.storage().reference()
			
		} else {
			// No user is signed in.
			performSegue(withIdentifier: "FROM_CAM_TO_AUTH", sender: nil)
			
		}
		
		self.magicSetup()
		
        print("\n FROM VIEW CON \n")
    }
	
	override func viewWillAppear(_ animated: Bool){
		super.viewWillAppear(animated)
		
		UIApplication.shared.isStatusBarHidden = true
		
		if !session.isRunning{
			
			session.startRunning()
			previewLayer.isHidden = false
			previewLayer.opacity = 1
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if self.session.isRunning{
			
			self.previewLayer.isHidden = true
			self.previewLayer.opacity = 0.0
			self.session.stopRunning()
			
		}
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    @IBAction func unwindToCam(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindByLogginOut(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func userAccountButtonAction(_ sender: UIBarButtonItem) {
        
        if let _ = FIRAuth.auth()?.currentUser {
            
            performSegue(withIdentifier: "FROM_CAM_TO_ACC", sender: nil)
            
        }else{
            
            performSegue(withIdentifier: "FROM_CAM_TO_AUTH", sender: nil)
            
        }
        
    }
    
    @IBAction func flashToogle(_ sender: UIBarButtonItem) {
        
        print("Flash Button Pressed")
        switch(sender.tag){
        case 101:
            sender.tag = 102
            sender.image = UIImage(named: "ic_flash_on_white_36pt")
            setCameraFlash(AVCaptureFlashMode.on, forDevice: &frontCamera!)
            break
        case 102:
            sender.tag = 100
            sender.image = UIImage(named: "ic_flash_off_white_36pt")
            setCameraFlash(AVCaptureFlashMode.off, forDevice: &frontCamera!)
            break
        default:
            sender.tag = 101
            sender.image = UIImage(named: "ic_flash_auto_white_36pt")
            setCameraFlash(AVCaptureFlashMode.auto, forDevice: &frontCamera!)
            break
        }
    }
    
    @IBAction func cameraToggle(_ sender: UIBarButtonItem) {
        
        self.previewLayer.opacity = 0.0
        sethostCALayerHidden(true)
        
        switch(sender.tag){
        case 200:
            sender.tag = 201
            sender.image = UIImage(named: "ic_camera_front_white_36pt")
            switchToCamera(position: .back)
            break
        default:
            sender.tag = 200
            sender.image = UIImage(named: "ic_camera_rear_white_36pt")
            switchToCamera(position: .front)
            break
        }
    }
	
	//Temporary Action for Photo Library
    @IBAction func helpAction(_ sender: UIBarButtonItem) {
        
		//Perform Segue to photo Library
		print("TRAVELING TO PHOTOS")
		performSegue(withIdentifier: "FROM_CAM_TO_PHOTOS", sender: nil)
		
    }
	
//	@IBAction func saveButt(sender: AnyObject) {
//		
//		
//	}

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let previewLayerConnection = previewLayer.connection {
            
            switch UIDevice.current.orientation {
            
            case .landscapeRight, .landscapeLeft:
                
                previewLayer.frame.size = size
                previewLayer.frame.origin = CGPoint(x: self.view.frame.origin.x - 84, y: self.view.frame.origin.y)
                
                self.navigationItem.leftBarButtonItems?.first?.isEnabled = false
                self.navigationItem.leftBarButtonItems?.first?.tintColor = UIColor.clear
                
                self.navigationItem.leftBarButtonItems?.last?.isEnabled = false
                self.navigationItem.leftBarButtonItems?.last?.tintColor = UIColor.clear
                
                break
                
            default:
                previewLayer.frame.size = size
                previewLayer.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 84)
                
                self.navigationItem.leftBarButtonItems?.first?.isEnabled = true
                self.navigationItem.leftBarButtonItems?.first?.tintColor = self.navigationItem.rightBarButtonItems?.first?.tintColor
                
                self.navigationItem.leftBarButtonItems?.last?.isEnabled = true
                self.navigationItem.leftBarButtonItems?.last?.tintColor = self.navigationItem.rightBarButtonItems?.first?.tintColor
                
                break
            }
            
            previewLayerConnection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
            
        }
    }
    
    /*
    // MARK: - Navigation
	*/
	
    // In a storyboard-based application, you will often want to do a little preparation
    // before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "FROM_CAM_TO_PREVIEW" {
			
			let nc = segue.destination as! UINavigationController
			let vc = nc.viewControllers.first as! TCPreviewImageViewController

			vc.cachedImage = cachedImage
			
		}
    }


	
	
	
}

extension TCCameraViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filterImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! TCFavoriteFiltersCollectionViewCell
		cell.imageCell.image = filterImages[indexPath.item]
		cell.cellIndexPath = indexPath
		cell.layer.cornerRadius = 30
		
		return cell
		
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		let tcCell = cell as! TCFavoriteFiltersCollectionViewCell
		if currentIndexPath?.item != indexPath.item {
			tcCell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		currentIndexPath = indexPath
		
		DispatchQueue.main.async() {
			
			let _ = collectionView.visibleCells.map { (cell) -> UICollectionViewCell in
				
				let tcCell = cell as! TCFavoriteFiltersCollectionViewCell
				tcCell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
				return tcCell
			}
			//
			
			let cCell = collectionView.cellForItem(at: indexPath) as! TCFavoriteFiltersCollectionViewCell
			self.currentFilter = self.filterImages[indexPath.item]
			self.faceCALayer.contents = self.currentFilter?.cgImage
			//collectionView.reloadItems(at: [indexPath])
			
			cCell.backgroundColor = #colorLiteral(red: 0.868450582, green: 0.3705046773, blue: 0.2716209292, alpha: 0.5)
			
		}
	}
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
            performSegue(withIdentifier: "FROM_CAM_TO_PHOTOS", sender: nil)
            break
        case 2:
            //Perfom take shot action
            //Perfom Segue to Preview Results
            print("TAKING SHOT EXECUTION")
			takeShot()
			
            break
        case 3:
            print("TRAVELING TO FILTERS")
            //Perform Segue to filter library
            performSegue(withIdentifier: "FROM_CAM_TO_FILTERS", sender: nil)
            break
        default:
            fatalError("THIS DEFAULT CASE MUST NEVER BE REACHED")
            break
        }
    }
	
	func takeShot(){
		
		if session.isRunning {
			
			sessionConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo)
			sessionConnection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
			stillImageOutput.captureStillImageAsynchronously(from: sessionConnection) {(sample, err) in
				
				//let imagebuff = CMGetAttachment(sample,  kCGImagePropertyExifDictionary, nil) as! CFDictionaryRef
				let imageShot = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sample) as Data
				
				self.magicRenderer(data: imageShot) { (toonyImage) in
					
					if let currentUser = FIRAuth.auth()?.currentUser {
						
						print("takeShot func on magic renderer call")
						debugPrint(currentUser)
						debugPrint(toonyImage)
						self.cachedImage = toonyImage
						
						self.performSegue(withIdentifier: "FROM_CAM_TO_PREVIEW", sender: nil)
						
					}
				}
				
//				let imageData = UIImageJPEGRepresentation(renderedimage, 0.6)!
//				self.cachedImage = UIImage(data: imageData)!
				
				
				//self.prepareAlbum()
				
				
				//UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
				
			}
			
		}else{
			print("⚠️ Could Not take picture due to the session is not running...")
		}

	}
	
	func prepareAlbum() {
		//Get PHFetch Options
		
		
		
//		let fetchOptions = PHFetchOptions()
//		fetchOptions.predicate = NSPredicate(format: "title = %@", "Toony Cam")
//		let collection : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//		//Check return value - If found, then get the first album out
//		if let _: AnyObject = collection.firstObject {
//			
//			self.albumFound = true
//			assetCollection = collection.firstObject! as PHAssetCollection
//			self.saveImage()
//			
//		} else {
//			
//			//If not found - Then create a new album
//			PHPhotoLibrary.shared().performChanges({
//				
//				let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Toony Cam")
//				
//				self.assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
//				
//				
//			}, completionHandler: { success, error in
//				self.albumFound = success
//				
//				if (success) {
//					
//					let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.assetCollectionPlaceholder.localIdentifier], options: nil)
//					
//					print(collectionFetchResult)
//					
//					self.assetCollection = collectionFetchResult.firstObject! as PHAssetCollection
//					
//					print(self.assetCollection)
//					
//					self.saveImage()
//				}
//			})
//		}
	}
	
	func saveImage(){
		
		
		storageRef.child("selfies").child("")
//		func addAsset(image: UIImage, to album: PHAssetCollection) {
//			
//			PHPhotoLibrary.shared().performChanges({
//				// Request creating an asset from the image.
//				let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//				// Request editing the album.
//				guard let addAssetRequest = PHAssetCollectionChangeRequest(for: album)
//					else { return }
//				// Get a placeholder for the new asset and add it to the album editing request.
//				addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
//				
//			}, completionHandler: { success, error in
//				if !success { NSLog("error creating asset: \(error)") }
//			})
//		}
		
//		PHPhotoLibrary.shared().performChanges({
//			
//			let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.cachedImage)
//			let assetPlaceholder = assetRequest.placeholderForCreatedAsset!
//			
//			guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) else {
//				return
//			}
//			
//			albumChangeRequest.addAssets(NSArray(array: [assetPlaceholder] ) )
//			
//			
//		}, completionHandler: { success, error in
//			
//			if success {
//				
//				print("added image to album")
//				
//			}else{
//					print(error!)
//			}
//		})
	}
}




