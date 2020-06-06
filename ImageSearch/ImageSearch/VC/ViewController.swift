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
    fileprivate var footerView : CustomReusableView?
    
    //MARK:- outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.register(UINib(nibName: "CustomReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CustomReusableView")
    }
    
}
   
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.rowCount{
            viewModel.searchForNextPage()
            footerView?.showLoader(show: viewModel.showBottomLoader)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if viewModel.showBottomLoader{
//            return
//        }

//        if let model = viewModel.getModel(indexPath: indexPath), let urlString = model.imageUrl{
//            ImageCacheLoader.sharedInstance.slowDownImageDownLoadTask(url: URL(string: urlString))
//        }
    }
        
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell{
            if let model = viewModel.getModel(index: indexPath.row){
                cell.configure(rowNumber: indexPath.row, model: model)
            }
            return cell
        }
            return UICollectionViewCell()
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "GalleryViewController") as? GalleryViewController{
            vc.scrollIndex = indexPath.row
            vc.viewModel = self.viewModel
            self.present(vc, animated: true, completion: nil)
        }
    }
    
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width/2
        return CGSize(width: width, height: width)
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CustomReusableView", for: indexPath) as! CustomReusableView
            view.showLoader(show: viewModel.showBottomLoader)
            footerView = view
            return view
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
        
}


extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
        
    @objc func reload(_ searchBar: UISearchBar){
        if let text = searchBar.text{
            viewModel.fetchModels(searchText: text)
        }
    }
}

extension ViewController : ImageSearchVMDelegate{
    func viewModelDidBeginSearching() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.activityIndicator.startAnimating()
        }
    }
        
    func viewModelDidEndSearching() {
         DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
        
    func viewModelRefreshData(){
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

