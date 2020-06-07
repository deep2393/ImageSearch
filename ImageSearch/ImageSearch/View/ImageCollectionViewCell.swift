//
//  ImageCollectionViewCell.swift
//  ImageSearch
//
//  Created by Deepak Singh on 05/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    //MARK:- outlets and variables
       @IBOutlet weak var imageView
        : UIImageView!
    private var localImageUrl : String?
    
    func configure(rowNumber: Int, model: ImageModelProtocol){
        imageView.image = nil
        localImageUrl = model.imageUrl
        model.fetchImage { [weak self](image, urlString, error) in
            guard let weakSelf = self else{
                return
            }
            if weakSelf.localImageUrl == urlString{
                self?.imageView.image = image
            }
        }
     }
    
}


final class AutoSuggestionTableViewCell : UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(model: AutoSuggestionModelProtocol){
        titleLabel.text = model.text
    }
}
