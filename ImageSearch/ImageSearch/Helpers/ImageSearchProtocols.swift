//
//  ImageSearchEnumsAndProtocol.swift
//  ImageSearch
//
//  Created by Deepak Singh on 05/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import UIKit


typealias ImageDownloadHandler = (_ image: UIImage?, _ url: String?, _ error: Error?) -> Void

protocol ImageModelProtocol{
    var imageUrl: String { get }
    func fetchImage(completion: @escaping ImageDownloadHandler)
}

protocol ImageSearchApiProtocol{
    func fetchImages(searchText: String, pageToSearch: Int, completionHandler : @escaping (_ models : [ImageModelProtocol], _ searchedText: String, Error?) -> Void)
}

protocol ImageSearchVMDelegate : class{
    func viewModelDidBeginSearching()
    func viewModelDidEndSearching()
    func viewModelRefreshData()
    func insertViews(indexes: [Int])
    func saveAutoSuggestText(text: String)
    func showErrorMsg(errorMsg: String)
}


protocol ImageSearchVMProtocol : NSObjectProtocol{
    var delegate : ImageSearchVMDelegate?{ get set }
    
    //ui related methods and variables
    var rowCount: Int { get }
    var showBottomLoader: Bool { get }
    func getModel(index: Int) -> ImageModelProtocol?
    
    //api related methods
    func searchForNextPage()
    func fetchModels(searchText: String)
}

protocol AutoSuggestionVMProtocol{
    //ui methods
    var modelCount: Int { get }
    var isDataSourceEmpty: Bool { get }
    func getModel(index: Int) -> AutoSuggestionModelProtocol?
  
    //fuctionality
    func saveModel(text: String)
}

protocol AutoSuggestionModelProtocol{
    var text : String { get }
}

protocol AutoSuggestionDBProtocol{
    func getAllModels() -> [AutoSuggestionModelProtocol]
    func saveModel(model: AutoSuggestionModelProtocol)
}


protocol UserDefaultMockProtocol{
    func set(_ items: Any?, forKey: String)
    func stringArray(forKey: String) -> [String]?
    @discardableResult func synchronize() -> Bool
}

enum ApiError{
    case noNetwork, noObjects, wrongConfig
    
    var errorMessage: String{
        switch self {
        case .noNetwork:
            return "Network connection error."
        case .noObjects:
            return "No objects found."
        case .wrongConfig:
            return "There is some issue in configuration."
        }
    }
    
    var errorObj: Error{
        return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
}
