//
//  File.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/7/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

extension TCCameraViewController: AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func magicSetup() {
        
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        let avaliableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in avaliableCameraDevices {
            
            switch device.position {
            case .front:
                frontCamera = device
                setCameraFlash(AVCaptureFlashMode.auto, forDevice: &frontCamera!)
                break
            case .back:
                backCamera = device
                setCameraFlash(AVCaptureFlashMode.auto, forDevice: &backCamera!)
                break
            default:
                fatalError("There is no camera on this device...")
                break
            }
            
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            if session.canAddInput(input){
                session.addInput(input)
            }else{
                print("Error !!!!")
            }
            
        } catch {
            print("Error handling the camera Input: \(error)")
            return
        }
        
        metadataOutput = AVCaptureMetadataOutput()
        stillImageOutput = AVCaptureStillImageOutput()
        
        // Setting 2 media output object configurations
        //
        if session.canAddOutput(metadataOutput) && session.canAddOutput(stillImageOutput) {
            
            session.addOutput(metadataOutput)
            
            stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG];
            
            session.addOutput(stillImageOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
            
        }else{
            fatalError("Can't add object metadata")
        }
        
        // Preparing the AV's camera feed's preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
		
        previewLayer.frame = view.frame
        previewLayer.zPosition = -100
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
        
//        previewLayer.frame.origin = CGPoint(x: 0, y: 0)
		
        view.layer.addSublayer(previewLayer)
        
        // Preparing the filter's Host layer
        //hostCALayer = CALayer()
        hostCALayer.zPosition = 1
        hostCALayer.frame = previewLayer.frame
//		hostCALayer.backgroundColor = #colorLiteral(red: 0.868450582, green: 0.3705046773, blue: 0.2716209292, alpha: 0.5).cgColor
//        hostCALayer.mask = faceCALayer
        //  \\ hostCALayer.borderColor = UIColor.red.cgColor
        // \\  hostCALayer.borderWidth = 3.0
        //hostCALayer.contents = UIImage(named: "dog_filter_p2")?.cgImage
        hostCALayer.contentsGravity = kCAGravityResizeAspectFill
        
        previewLayer.addSublayer(hostCALayer)
        
        //for i in 0...2 {
            
            //faceCALayer = CALayer()
            faceCALayer.zPosition = 2
            faceCALayer.isHidden = true
            //faceCALayer.contents = UIImage(named: "filter_\(i)")?.cgImage
            faceCALayer.contentsGravity = kCAGravityResize
            self.hostCALayer.addSublayer(faceCALayer)
            
		//}
		
    }
	    
    func setCameraFlash(_ flashMode:AVCaptureFlashMode, forDevice device: inout AVCaptureDevice) {
        
        if session.isRunning && device.hasFlash {
            
            if device.isFlashModeSupported(flashMode) {
                do {
                    try device.lockForConfiguration()
                    device.flashMode = flashMode
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting the currentDevice: \(error)")
                }
            }
        }
    }
    
    func sethostCALayerHidden(_ hidden: Bool) {
        if (hostCALayer.isHidden != hidden){
            DispatchQueue.main.async(execute:{() -> Void in
                self.hostCALayer.isHidden = hidden
            })
        }
    }
    
    func switchToCamera(position: AVCaptureDevicePosition){
        
        let currentInput = session.inputs.first as! AVCaptureDeviceInput
        self.session.removeInput(currentInput)
        
        do {
            
            let device = (position == .front ? frontCamera : backCamera)
            let input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input){
                session.addInput(input)
                
                self.previewLayer.opacity = 1.0
                sethostCALayerHidden(false)
                
            }else{
                print("Error !!!! Couldn't switch inputs by adding the new input")
            }
            
        } catch {
            print("Error switching camera Input: \(error)")
            return
        }
    }
    
    func findMaxFaceRect(_ faces : Array<CGRect>) -> CGRect {
        
        if faces.count == 1 { return faces.first! }
        
        var maxFace = CGRect.zero
        var maxFace_size = maxFace.size.width + maxFace.size.height
        
        for face in faces {
            
            let face_size = face.size.width + face.size.height
            
            if (face_size > maxFace_size) {
                maxFace = face
                maxFace_size = face_size
            }
        }
        
        return maxFace
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        
        var faces = [AVMetadataFaceObject]()
        
        for metadataObject in metadataObjects as! [AVMetadataObject] {
            if metadataObject.type == AVMetadataObjectTypeFace {
                faces += [metadataObject as! AVMetadataFaceObject]
            }else{
                print("NO FACE Object")
            }
        }
        
        for l in self.hostCALayer.sublayers!.enumerated() {
            if l.offset >= faces.count {
                DispatchQueue.main.async() {
                    l.element.isHidden = true
                }
            }
        }
        
        if faces.count <= 0 {
            sethostCALayerHidden(true)
        }else{
            sethostCALayerHidden(false)
        }

        for face in faces.enumerated() {
            
            //if let faceLayer = self.hostCALayer.sublayers?[face.offset] {
                
                let faceBounds = self.previewLayer.transformedMetadataObject(for: face.element).bounds
                
                 DispatchQueue.main.async() {
                    
                    self.faceCALayer.name = "\(face.element.faceID)"
                    self.faceCALayer.frame = faceBounds
                    self.faceCALayer.isHidden = false
                    //faceLayer.backgroundColor = UIColor.green.cgColor
                    //faceLayer.opacity = 0.5
                    
                    self.faceCALayer.removeAllAnimations()
                    
                    let cSize = self.faceCALayer.frame.size
                    let cO = self.faceCALayer.frame.origin
                    
                    self.faceCALayer.frame.size = CGSize( width: (cSize.width * 1.5), height: (cSize.height * 1.5) )
                    let cameraInput = self.session.inputs.first as! AVCaptureDeviceInput
                    
                    if cameraInput.device.position == .front {
                        
                        self.faceCALayer.frame.origin = CGPoint(x: cO.x - (cSize.width * 0.25),y: cO.y - (cSize.height / 2) )
                        
                    }else{
                        
                        self.faceCALayer.frame.origin = CGPoint(x: cO.x - (cSize.width * 0.25),y: cO.y - (cSize.height / 2.5) )
                        
                    }
                }
            //}
			
        //TODO: Need fix for bug with rotation
        //self.faceLayer.transform = CATransform3DMakeRotation(CGFloat(rawFace.rollAngle * CGFloat(M_PI / 180) ), 0.0, 0.0, 0.0)
        }
    }

	func magicRenderer(data:Data, completionBlock: (_ toonyImage: UIImage)->Void ) -> Void {
		
		var uiImage = UIImage()
		var imageData = Data()
		
		//
		var faceLayer = CALayer()
		
		// Core Image variables
		var ciImageCore:CIImage?
		var ciDetector:CIDetector?
		let ciContext = CIContext()
		
		var faces = [CIFaceFeature]()
		
		uiImage = UIImage(data: data)!
		ciImageCore = CIImage(data: data)
		
		ciDetector = CIDetector(ofType: CIDetectorTypeFace, context: ciContext, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])
		
		//var faceObj = objects.first! as! CIFaceFeature
		
		var exifOrientation: Int;
		
		switch (uiImage.imageOrientation) {
		case .up:
			exifOrientation = 1;
			break;
		case .down:
			exifOrientation = 3;
			break;
		case .left:
			exifOrientation = 8;
			break;
		case .right:
			exifOrientation = 6;
			break;
		case .upMirrored:
			exifOrientation = 2;
			break;
		case .downMirrored:
			exifOrientation = 4;
			break;
		case .leftMirrored:
			exifOrientation = 5;
			break;
		case .rightMirrored:
			exifOrientation = 7;
			break;
		}
		
		//print(exifOrientation)
		
		let objects = ciDetector!.features(in: ciImageCore!, options: [CIDetectorImageOrientation : exifOrientation])
		
		for fo in objects {
			if let cff = fo as? CIFaceFeature {
				faces += [cff]
			}
		}
			
		var newMemeImage: UIImage = UIImage()
		
		for faceObj in faces.enumerated(){
			
			let face = faceObj.element
			
			let layer = CALayer()
			
			layer.bounds = face.bounds
			layer.contents = currentFilter?.cgImage
			layer.contentsGravity = kCAGravityResizeAspectFill

			//layer.bounds.size = CGSize(width: face.bounds.size.width * 1.5, height: face.bounds.size.height * 1.5)
			
			layer.bounds.origin = CGPoint(x: face.bounds.origin.y, y: face.bounds.origin.x * 0.8)
			
			UIGraphicsBeginImageContext(uiImage.size)
		
			uiImage.draw(in: CGRect(x: 0, y: 0, width: uiImage.size.width, height: uiImage.size.height))
			
			let context = UIGraphicsGetCurrentContext()
			
			layer.render(in: context!)
			
			newMemeImage = UIGraphicsGetImageFromCurrentImageContext()!
			
			UIGraphicsEndImageContext()
			
		}
		
		completionBlock(newMemeImage)
		
	}
}
