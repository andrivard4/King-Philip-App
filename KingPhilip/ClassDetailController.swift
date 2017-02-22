//
//  ClassDetailController.swift
//  KingPhilip
//
//  Created by Andrew Rivard on 1/30/17.
//  Copyright © 2017 Andrew Rivard. All rights reserved.
//

import UIKit

class ClassDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let BasicHeaderID = "BaiscHeaderID"
    
    var icon: Icon? {
        didSet{
            navigationItem.title = icon?.icon
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(BasicHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: BasicHeaderID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BasicHeaderID, for: indexPath) as! BasicHeader
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.3)
    }
}
