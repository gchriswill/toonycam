//
//  TCPhotosCollectionViewCell.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/8/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

class TCPhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var shareButton: UIButton!
    
    @IBInspectable var tcRadius:CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = self.tcRadius
        }
    }
    
    @IBInspectable var cellImage:UIImage? = nil {
        didSet{
            self.imageCell.image = self.cellImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.defaultedCell()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.defaultedCell()
    }
    
    func defaultedCell() -> Void {
        self.layer.cornerRadius = self.tcRadius
        
    }
    
    // TODO: Implement share action
    @IBAction func shareAction(_ sender: UIButton) {
        
    }
    
}
