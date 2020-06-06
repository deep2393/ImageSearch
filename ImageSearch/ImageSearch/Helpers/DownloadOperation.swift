//
//  DownloadOperation.swift
//  ImageSearch
//
//  Created by Deepak Singh on 05/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//
import Foundation
import UIKit



class ImageDownloadOperation : AsyncOperation{
    
    //MARK:- variables
    let imageUrl : URL
    var downloadHandler: ImageDownloadHandler?
    
    //MARK:- methods
    override func main() {
        downloadImageFromUrl()
    }
    
    required init (url: URL) {
        self.imageUrl = url
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: imageUrl) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                self.downloadHandler?(image,self.imageUrl.absoluteString,error)
            }
            self.state = .finished
        }
        downloadTask.resume()
    }
}
