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
    private static let kApiKey = "16932502-cad5e5c2329f2b6c50b5ca759"
    private static let kPerPageCount = 20
    
    static var assembledURLString : String{
        return "\(kApiUrl)?key=\(kApiKey)&per_page=\(kPerPageCount)&image_type=photo"
    }
    
    static func collectiveUrlString(searchString: String, pageToSearch: Int) -> String{
        let combinedUrl = assembledURLString + "&q=\(searchString)&page=\(pageToSearch)"
        return combinedUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
}

final class ImageSearchApiHandler: ImageSearchApiProtocol{
    func fetchImages(searchText: String, pageToSearch: Int, completionHandler: @escaping ([ImageModelProtocol], String, Error?) -> Void) {
        guard let connectionState = try? Reachability().connection, connectionState != .unavailable else{
            completionHandler([], searchText, ApiError.noNetwork.errorObj)
            return
        }
        
        guard let url = URL(string: ApiConfiguration.collectiveUrlString(searchString: searchText, pageToSearch: pageToSearch)) else{
            completionHandler([], searchText, ApiError.wrongConfig.errorObj)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let urltask = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let unwrappedData = data,
                let modelContainer = try? JSONDecoder().decode(ImageModelContainer.self, from: unwrappedData){
                if modelContainer.hits.isEmpty{
                    completionHandler([], searchText, ApiError.noObjects.errorObj)
                }
                else{
                    completionHandler(modelContainer.hits, searchText, nil)
                }
            }else{
                completionHandler([], searchText, error)
            }
        }
        urltask.resume()
    }
    
    
}
