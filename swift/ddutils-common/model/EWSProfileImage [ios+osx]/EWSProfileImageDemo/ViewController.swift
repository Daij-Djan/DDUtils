//
//  ViewController.swift
//  EWSProfileImageDemo
//
//  Created by Dominik Pich on 7/9/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    let emails = ["dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com", "dpich@sapient.com", "mroehl@sapient.com", "hscheele@sapient.com", "shabeeb2@sapient.com", "fheimbrecht@sapient.com", "smakhlof@sapient.com"]
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emails.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profileImage", forIndexPath: indexPath)
        
        let email = emails[indexPath.item];
        let profileImage = try! EWSProfileImages.shared.get(email) { (loadedProfileImage) in
            guard let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) where cellToUpdate.tag == loadedProfileImage.email.hash else {
                return
            }
            
            guard let imageView = cellToUpdate.contentView.subviews.first as? UIImageView else {
                return
            }
            
            imageView.image = loadedProfileImage.image
        }

        cell.tag = email.hash
        
        if let imageView = cell.contentView.subviews.first as? UIImageView {
            imageView.image = profileImage.image
            imageView.contentMode = .ScaleAspectFit
        }
        
        return cell;
    }
}

