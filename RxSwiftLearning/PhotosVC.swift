//
//  PhotosVC.swift
//  RxSwiftLearning
//
//  Created by Joao Paulo Aquino on 10/08/19.
//  Copyright © 2019 Joao Paulo Aquino. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa


class PhotosVC: UICollectionViewController {
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    private var images = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization {[ weak self]
            status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                    
                }
                
                self?.images.reverse()
                DispatchQueue.main.async {

                self?.collectionView.reloadData()
                }
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let img = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: img, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: nil) { (image, _) in
            DispatchQueue.main.async {
                cell.imgView.image = image
            }
            
        }
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          let selectedAsset = self.images[indexPath.row]
          PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
              
             // guard let info = info else { return }
              
              //let isDegradedImage = info["PHImageResultIsDegradedKey"] as? Bool
              
                  
                  if let image = image {
                      self?.selectedPhotoSubject.onNext(image)
                      self?.dismiss(animated: true, completion: nil)
                  
              }
              
          }
          
      }
    
    
}
