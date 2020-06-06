//
//  DataModels.swift
//  ImageSearch
//
//  Created by Deepak Singh on 06/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import UIKit

final class ImageModel : Decodable, ImageModelProtocol{
    var imageUrl: String{
        return largeImageURL
    }
    
    let id : Int64
    let largeImageURL: String
    
    func fetchImage(completion: @escaping ImageDownloadHandler){
        ImageCacheLoader.sharedInstance.obtainImageWithPath(url: largeImageURL, completionHandler: completion)
    }
}

struct ImageModelContainer: Decodable{
    let hits: [ImageModel]
}

struct ImageAutoSuggestionModel: AutoSuggestionModelProtocol{
    var text: String
}

