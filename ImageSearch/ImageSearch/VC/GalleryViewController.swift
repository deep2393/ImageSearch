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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         collectionView.scrollToItem(at: IndexPath(row: scrollIndex, section: 0), at: .left, animated: true)
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
