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
    let viewModel : ImageSearchVMProtocol = ImageSearchVM()
    let autoSuggestionVM : AutoSuggestionVMProtocol = AutoSuggestionVM()
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var footerView : CustomReusableView?
    
    //MARK:- outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var autoSuggestionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.register(UINib(nibName: "CustomReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CustomReusableView")
    }
    
    
    //MARK:- Helper methods
    func manageAutoSuggestionViewHiding(show: Bool){
        if show{
            autoSuggestionTableView.isHidden = autoSuggestionVM.isDataSourceEmpty
        }else{
             autoSuggestionTableView.isHidden = true
        }
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
       
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as?     GalleryViewController{
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        manageAutoSuggestionViewHiding(show: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
        
    @objc func reload(_ searchBar: UISearchBar){
        if let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            manageAutoSuggestionViewHiding(show: false)
            viewModel.fetchModels(searchText: text)
            manageAutoSuggestionViewHiding(show: text.isEmpty)
        }
    }
}

extension ViewController : ImageSearchVMDelegate{
    func insertViews(indexes: [Int]) {
        var indexPathArr = [IndexPath]()
        for indexObj in indexes{
            indexPathArr.append(IndexPath(item: indexObj, section: 0))
        }
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.insertItems(at: indexPathArr)
        }
    }
    
    func saveAutoSuggestText(text: String) {
        autoSuggestionVM.saveModel(text: text)
        DispatchQueue.main.async { [weak self] in
            self?.autoSuggestionTableView.reloadData()
        }
    }
    
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

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:  "AutoSuggestionTableViewCell") as? AutoSuggestionTableViewCell{
            if let model = autoSuggestionVM.getModel(index: indexPath.row){
                cell.configure(model: model)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoSuggestionVM.modelCount
    }

}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = autoSuggestionVM.getModel(index: indexPath.row){
            searchBar.text = model.text
            reload(searchBar)
        }
    }
}
