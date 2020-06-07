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
    private var currentPage : Int = 1
    private var isRequestingNextPage: Bool = false
    private var currentSearchedText : String = ""
    
    var showBottomLoader: Bool {
        return isRequestingNextPage
    }
    
    //MARK:- init
    init(dataModels: [ImageModelProtocol] = [],
         apiHandler : ImageSearchApiProtocol = ImageSearchApiHandler()) {
        self.dataModels = dataModels
        self.apiHandler = apiHandler
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
            apiHandler.fetchImages(searchText: searchText, pageToSearch: currentPage) { [weak self](models, searchText, error)   in
                guard let weakSelf = self else{
                    return
                }
                if !models.isEmpty{
                    weakSelf.dataModels.append(contentsOf: models)
                    weakSelf.delegate?.saveAutoSuggestText(text: searchText)
                }else if let errorObj = error{
                    //check for error
                    weakSelf.delegate?.showErrorMsg(errorMsg: errorObj.localizedDescription)
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
            apiHandler.fetchImages(searchText: currentSearchedText, pageToSearch: currentPage) { [weak self](models, _, _)   in
                guard let weakSelf = self else{
                    return
                }
                
                let existingModelCount = weakSelf.dataModels.count
                weakSelf.dataModels.append(contentsOf: models)
                let finalModelCount = weakSelf.dataModels.count - 1
                
                weakSelf.isRequestingNextPage = false
                weakSelf.delegate?.insertViews(indexes: [Int](existingModelCount ... finalModelCount))
            }
        }
    }
    
    //MARK:- helper methods
    private func resetValues(){
        currentPage = 1
        dataModels.removeAll()
        isRequestingNextPage = false
    }
    
}
