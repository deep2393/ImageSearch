//
//  CustomReusableView.swift
//  ImageSearch
//
//  Created by Deepak Singh on 05/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//


import UIKit

class CustomReusableView: UICollectionReusableView {
    //MARK:- outlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- function
    func showLoader(show : Bool){
        if show{
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
}
