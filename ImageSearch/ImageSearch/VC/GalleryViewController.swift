//
//  GalleryViewController.swift
//  ImageSearch
//
//  Created by Deepak Singh on 06/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    //MARK:- outlets and variables
    @IBOutlet weak var collectionView: UICollectionView!
    weak var viewModel: ImageSearchVMProtocol?
    var scrollIndex: Int = 0
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollToIndexAfterDelay()
    }
    
    //MARK:- Helper methods
    func scrollToIndexAfterDelay(){
        let kDelayedMilliSeconds : Int = 100
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(kDelayedMilliSeconds)) { [weak self] in
            guard let weakSelf = self else{
                return
            }
            weakSelf.changeScrollPositionBasedOnIndex(index: weakSelf.scrollIndex)
        }
    }
    
    
    func changeScrollPositionBasedOnIndex(index: Int){
        let cellYPosition = UIScreen.main.bounds.width * CGFloat(scrollIndex)
        collectionView.contentOffset = CGPoint(x: cellYPosition, y: 0)
    }
}

extension GalleryViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.rowCount ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell{
            if let model = viewModel?.getModel(index: indexPath.row){
                cell.configure(rowNumber: indexPath.row, model: model)
            }
            return cell
        }
            return UICollectionViewCell()
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
}
