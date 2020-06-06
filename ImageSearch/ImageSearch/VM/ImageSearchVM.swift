//
//  ImageSearchVM.swift
//  ImageSearch
//
//  Created by Deepak Singh on 05/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import UIKit

final class ImageSearchVM: NSObject, ImageSearchVMProtocol {
    //MARK:- variables
    weak var delegate: ImageSearchVMDelegate?
    var dataModels : [ImageModelProtocol]
    let apiHandler : ImageSearchApiProtocol
    var currentPage : Int = 1
    var isRequestingNextPage: Bool = false
    var currentSearchedText : String = ""
    
    var showBottomLoader: Bool {
        return isRequestingNextPage
    }
    
    //MARK:- init
    override init() {
        dataModels = []
        apiHandler = ImageSearchApiHandler()
    }
    
    //MARK:- UI related methods and variables
    var rowCount: Int{
        return dataModels.count
    }
    
    func getModel(index: Int) -> ImageModelProtocol? {
        if index < rowCount{
            return dataModels[index]
        }else{
            return nil
        }
    }
    
    //MARK:- api related methods
    func fetchModels(searchText: String) {
        resetValues()
        delegate?.viewModelDidBeginSearching()
        
        if !searchText.isEmpty{
            apiHandler.fetchImages(searchText: searchText, pageToSearch: currentPage) { [weak self](models, searchText)  in
                guard let weakSelf = self else{
                    return
                }
                if !models.isEmpty{
                    weakSelf.dataModels.append(contentsOf: models)
                    weakSelf.delegate?.saveAutoSuggestText(text: searchText)
                }
                    weakSelf.delegate?.viewModelDidEndSearching()
                    weakSelf.delegate?.viewModelRefreshData()
            }
        }else{
            delegate?.viewModelDidEndSearching()
            delegate?.viewModelRefreshData()
        }
    }
    
    func searchForNextPage() {
        if !isRequestingNextPage{
            currentPage += 1
            isRequestingNextPage = true
            apiHandler.fetchImages(searchText: currentSearchedText, pageToSearch: currentPage) { [weak self](models, _)  in
                guard let weakSelf = self else{
                    return
                }
                
                weakSelf.dataModels.append(contentsOf: models)
                weakSelf.isRequestingNextPage = false
                weakSelf.delegate?.viewModelRefreshData()
            }
        }
    }
    
    //MARK:- helper methods
    func resetValues(){
        currentPage = 1
        dataModels.removeAll()
        isRequestingNextPage = false
    }
    
}
