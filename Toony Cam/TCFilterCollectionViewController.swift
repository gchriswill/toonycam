//
//  TCFilterCollectionViewController.swift
//  Toony Cam
//
//  Created by Christopher Gonzalez on 11/6/16.
//  Copyright © 2016 Parthenon Studios. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TC_FILTERS_CELL"

class TCFilterCollectionViewController: UICollectionViewController {
    
    var items = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fatalError()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView?.isScrollEnabled = true
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if let vc_2 = segue.destination as? TCPreviewCollectionViewController {
            
            vc_2.useLayoutToLayoutNavigationTransitions = true
            
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
        
        return items
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TCFiltersCollectionViewCell
        
        cell.isUserInteractionEnabled = true
        cell.shareButton.isHidden = true
        cell.shareButton.isEnabled = false
        
        return cell
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
     
    override func collectionView(_ collectionView: UICollectionView, 
     shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
     
    override func collectionView(_ collectionView: UICollectionView, 
     shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified 
    // item, and react to actions performed on the item
     
    override func collectionView(_ collectionView: UICollectionView, 
     shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, 
     canPerformAction action: Selector, 
     forItemAt indexPath: IndexPath,
     withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, 
     performAction action: Selector, 
     forItemAt indexPath: IndexPath,
     withSender sender: Any?) {
    
    }
    */

}
