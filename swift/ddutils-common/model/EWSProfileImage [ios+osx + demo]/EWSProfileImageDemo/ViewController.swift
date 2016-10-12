//
//  ViewController.swift
//  EWSProfileImageDemo
//
//  Created by Dominik Pich on 7/9/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    let emails = ["dpich@sapient.com", "mroehl@sapient.com", "shabeeb2@sapient.com",
                  "dpich@sapient.com", "mroehl@sapient.com", "shabeeb2@sapient.com",
                  "dpich@sapient.com", "mroehl@sapient.com", "shabeeb2@sapient.com",
                  "dpich@sapient.com", "mroehl@sapient.com", "shabeeb2@sapient.com",
                  "dpich@sapient.com", "mroehl@sapient.com", "shabeeb2@sapient.com",
                  "dpich@sapient.com", "mroehl@sapient.com", "shabeeb2@sapient.com",
                  "dpich@sapient.com", "mroehl@sapient.com", "shabeeb2@sapient.com"]
                  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileImage", for: indexPath)
        
        let email = emails[(indexPath as NSIndexPath).item];
        let profileImage = try! EWSProfileImages.shared.get(email) { (loadedProfileImage) in
            guard let cellToUpdate = collectionView.cellForItem(at: indexPath) , cellToUpdate.tag == loadedProfileImage.email.hash else {
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
            imageView.contentMode = .scaleAspectFit
        }
        
        return cell;
    }
}

