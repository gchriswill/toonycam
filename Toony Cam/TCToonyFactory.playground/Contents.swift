

//: Toony Cam's Factory
//: ====================
//:
//:
//: > Toony Cam's Factory is the playground file where we build our local components.
//: For more information about Toony Cam, please visit Toony Cam's repository
//:
//: _**TCActivityIndicator.swift**_
//:
//: `Created by Christopher Gonzalez on 11/3/16.`
//:

import UIKit

//: ### Keyboard Show/Hide Notifications
//:
//: > Functions to track the keyboard notifications and animate the credentials panel when 
//: the keyboard appears and disapear...
//:
//func willShowKeyboard(notification: NSNotification) {
//    
//    if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//        print("\n TCAuthViewController --> willShowKeyboard")
//        if credentialsPanel.controlPanelMover.constant == 0 {
//            
//            UIView.animate(withDuration: 0.75,
//                           delay: 0.4,
//                           usingSpringWithDamping: 0.9,
//                           initialSpringVelocity: 0.8,
//                           options: UIViewAnimationOptions.curveEaseOut,
//                           animations: {
//                            
//                            self.credentialsPanel.controlPanelMover.constant = -110
//                            self.credentialsPanel.layoutIfNeeded()
//                            
//            }) { (check) in
//                
//                
//            }
//        }
//    }
//}
//
//func willHideKeyboard(notification: NSNotification) {
//    
//    if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//        print("\n TCAuthViewController --> willHideKeyboard")
//        if credentialsPanel.controlPanelMover.constant != 0 {
//            UIView.animate(withDuration: 0.75,
//                           delay: 0.4,
//                           usingSpringWithDamping: 0.9,
//                           initialSpringVelocity: 0.8,
//                           options: UIViewAnimationOptions.curveEaseOut,
//                           animations: {
//                            
//                            self.credentialsPanel.controlPanelMover.constant = 0
//                            self.credentialsPanel.layoutIfNeeded()
//                            
//            }) { (check) in
//                
//                
//            }
//        }
//    }
//}

//: ### Material Activity Indicator
//:
//: > Working on a custo Meterial activity indicator
//:
//:
//class TCActivityIndicator: UIView {
//
//    /** Specifies the timing function to use for the control's animation. Defaults to kCAMediaTimingFunctionEaseInEaseOut */
//    var timingFunction: CAMediaTimingFunction!
//    
//    /** Property indicating whether the view is currently animating. */
//    var isAnimating = false
//    
//    /** Property indicating the duration of the animation, default is 1.5s. Should be set prior to -[startAnimating] */
//    var duration: TimeInterval!
//    
//    var progressLayer:CAShapeLayer! {
//        
//        get{
//            
//            if (self.progressLayer == nil) {
//                
//                let pl = CAShapeLayer(layer: layer)
//                pl.strokeColor = self.tintColor.cgColor;
//                pl.fillColor = nil;
//                pl.lineWidth = 1.5;
//                
//                return pl
//            }
//            
//            self.progressLayer.strokeColor = self.tintColor.cgColor;
//            self.progressLayer.fillColor = nil;
//            self.progressLayer.lineWidth = 1.5;
//            
//            return self.progressLayer
//        }
//    }
//    
//    /** Sets the line width of the spinner's circle. */
//    var lineWidth: CGFloat {
//        get{
//            return self.progressLayer.lineWidth
//        }
//        
//        set{
//            self.progressLayer.lineWidth = self.lineWidth
//            self.updatePath()
//        }
//    }
//    
//    /** Sets whether the view is hidden when not animating. */
//    var hidesWhenStopped = true {
//        didSet{
//            self.isHidden = !self.isAnimating && self.hidesWhenStopped
//        }
//    }
//    
//    override init(frame:CGRect) {
//        super.init(frame:frame)
//        initialize()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        //fatalError("init(coder:) has not been implemented")
//        initialize()
//    }
//    
//    func initialize(){
//        
//        self.duration = 1.5
//        
//        timingFunction = CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseInEaseOut)
//        
//        self.layer.addSublayer(self.progressLayer)
//        
//        // See comment in resetAnimations on why this notification is used.
//        NotificationCenter.default.addObserver(self,
//                                               selector:#selector(TCActivityIndicator.resetAnimations),
//                                               name:NSNotification.Name.UIApplicationDidBecomeActive,
//                                               object:nil)
//        
//    }
//    
//    
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.progressLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
//        self.updatePath()
//    }
//    
//    override func tintColorDidChange() {
//        super.tintColorDidChange()
//        self.progressLayer.strokeColor = self.tintColor.cgColor
//    }
//    
//    func resetAnimations() {
//        
//        // If the app goes to the background, returning it to the foreground causes the animation to stop (even though it's not explicitly stopped by the code). Resetting the animation seems to kick it back into gear.
//        if (self.isAnimating) {
//            self.stopAnimating()
//            self.startAnimating()
//        }
//    }
//    
//    func startAnimating() {
//        
//        if (self.isAnimating) {
//            return
//        }
//        
//        let animation = CABasicAnimation(keyPath:"transform.rotation")
//        animation.duration = self.duration / 0.375
//        animation.fromValue = 0
//        animation.toValue = 2 * M_PI
//        animation.repeatCount = HUGE
//        animation.isRemovedOnCompletion = false
//        
//        self.progressLayer.add(animation, forKey:"rotation");
//        
//        let headAnimation = CABasicAnimation(keyPath:"strokeStart")
//        headAnimation.duration = self.duration / 1.5
//        headAnimation.fromValue = 0
//        headAnimation.toValue = 0.25
//        headAnimation.timingFunction = self.timingFunction;
//        
//        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        tailAnimation.duration = self.duration / 1.5
//        tailAnimation.fromValue = 0
//        tailAnimation.toValue = 1
//        tailAnimation.timingFunction = self.timingFunction
//        
//        
//        let endHeadAnimation = CABasicAnimation(keyPath:"strokeStart")
//        endHeadAnimation.beginTime = self.duration / 1.5
//        endHeadAnimation.duration = self.duration / 3.0
//        endHeadAnimation.fromValue = 0.25
//        endHeadAnimation.toValue = 1
//        endHeadAnimation.timingFunction = self.timingFunction;
//        
//        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        endTailAnimation.beginTime = self.duration / 1.5
//        endTailAnimation.duration = self.duration / 3.0
//        endTailAnimation.fromValue = 1
//        endTailAnimation.toValue = 1
//        endTailAnimation.timingFunction = self.timingFunction;
//        
//        let animations = CAAnimationGroup()
//        animations.duration = self.duration
//        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
//        animations.repeatCount = HUGE
//        animations.isRemovedOnCompletion = false
//        
//        self.progressLayer.add(animations, forKey:"rotation");
//        
//        
//        self.isAnimating = true;
//        
//        if (self.hidesWhenStopped) {
//            self.isHidden = false
//        }
//    }
//    
//    func stopAnimating() {
//        
//        if (!self.isAnimating){
//            return
//        }
//        
//        self.progressLayer.removeAnimation(forKey:"rotation")
//        self.progressLayer.removeAnimation(forKey:"rotation")
//        self.isAnimating = false
//        
//        if (self.hidesWhenStopped) {
//            self.isHidden = true
//        }
//    }
//    
//    //#pragma mark - Private
//    
//    func updatePath() {
//        
//        let center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
//        
//        let radius = min(self.bounds.width / 2, self.bounds.height / 2) - self.progressLayer.lineWidth / 2
//        
//        let startAngle: CGFloat = 0
//        
//        let endAngle: CGFloat = CGFloat(2) * CGFloat(M_PI)
//        
//        let path: UIBezierPath = UIBezierPath(arcCenter:center,
//                                              radius:radius,
//                                              startAngle:startAngle,
//                                              endAngle:endAngle,
//                                              clockwise:true)
//        
//        self.progressLayer.path = path.cgPath
//        
//        self.progressLayer.strokeStart = 0
//        
//        self.progressLayer.strokeEnd = 0
//    }
//}

//var myView = TCActivityIndicator(frame:CGRect(x: 0, y: 0, width: 200, height: 200) )


let data = try Data(contentsOf: URL(string: "http://pbs.twimg.com/profile_images/693702786131857408/_HGwqa7c_normal.jpg")!)

let aImage = UIImage(data: data)


