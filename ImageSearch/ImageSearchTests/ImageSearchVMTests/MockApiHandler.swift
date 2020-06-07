//
//  MockApiHandler.swift
//  ImageSearchTests
//
//  Created by Deepak Singh on 07/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import Foundation


struct MockApiHandler : ImageSearchApiProtocol{
    func fetchImages(searchText: String, pageToSearch: Int, completionHandler: @escaping ([ImageModelProtocol], String, Error?) -> Void) {
        if searchText == "Test"{
            let models = [MockImageModel(imageUrl: "Test1"), MockImageModel(imageUrl: "Test2"), MockImageModel(imageUrl: "Test3"), MockImageModel(imageUrl: "Test4")]
            
            completionHandler(models, searchText, nil)
        }else{
            completionHandler([], searchText, ApiError.noObjects.errorObj)
        }
    }
}

struct MockImageModel: ImageModelProtocol{
    var imageUrl: String
    
    func fetchImage(completion: @escaping ImageDownloadHandler) {
        completion(nil, imageUrl, nil)
    }
}
