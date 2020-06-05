//
//  ViewController.swift
//  ImageSearch
//
//  Created by Deepak Singh on 05/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK:- variables
    var viewModel : ImageSearchVMProtocol = ImageSearchVM()
    //MARK:- outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


}

