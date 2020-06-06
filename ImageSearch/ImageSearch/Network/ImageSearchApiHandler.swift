//
//  ImageSearchApiHandler.swift
//  ImageSearch
//
//  Created by Deepak Singh on 06/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import Foundation

struct ApiConfiguration{
    private static let kApiUrl = "https://pixabay.com/api"
    private static let kApiKey = "16911716-74344128c9ed60934110e4bd4"
    private static let kPerPageCount = 10
    
    static var assembledURLString : String{
        return "\(kApiUrl)?key=\(kApiKey)&per_page=\(kPerPageCount)&image_type=photo"
    }
    
    static func collectiveUrlString(searchString: String, pageToSearch: Int) -> String{
        let combinedUrl = assembledURLString + "&q=\(searchString)&page=\(pageToSearch)"
        return combinedUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
}

final class ImageSearchApiHandler: ImageSearchApiProtocol{
    func fetchImages(searchText: String, pageToSearch: Int, completionHandler: @escaping ([ImageModelProtocol], String) -> Void) {
        guard let url = URL(string: ApiConfiguration.collectiveUrlString(searchString: searchText, pageToSearch: pageToSearch)) else{
            completionHandler([], searchText)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let urltask = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let unwrappedData = data,
                let modelContainer = try? JSONDecoder().decode(ImageModelContainer.self, from: unwrappedData){
                completionHandler(modelContainer.hits, searchText)
            }else{
                completionHandler([], searchText)
            }
        }
        urltask.resume()
    }
    
    
}
