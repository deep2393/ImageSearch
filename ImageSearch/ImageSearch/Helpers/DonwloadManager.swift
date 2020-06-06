//
//  DownloadManager.swift
//  ImageSearch
//
//  Created by Deepak Singh on 06/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import Foundation
import UIKit

//MARK:- image caching
final class ImageCacheLoader {
    //MARK:- variables
    private var cache = NSCache<NSString, UIImage>()
    static let sharedInstance = ImageCacheLoader()
    
    //MARK:- internal queue
    lazy private var imageDownloadQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "DownloadOperationQueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    //MARK:- private init
    private init(){}
    
    
    //MARK: methods
    func obtainImageWithPath(url: String, completionHandler: @escaping ImageDownloadHandler) {
        //early exit
        guard let imageUrl = URL(string: url) else{
            completionHandler(nil,url,nil)
            return
        }
        
        //check for cache
        if let image = self.cache.object(forKey: imageUrl.absoluteString as NSString) {
            completionHandler(image, url, nil)
        } else {
            //check for exisiting operation
            if let operation = imageDownloadQueue.operations.filter({ (obj) -> Bool in
                if let downloadOperation = obj as? ImageDownloadOperation{
                    return downloadOperation.imageUrl == imageUrl && downloadOperation.state == .executing
                }
                return false
            }).first{
                //increase priority
                operation.queuePriority = .veryHigh
            }
            //create a new task
            else{
                let operation = ImageDownloadOperation(url: imageUrl)
                operation.downloadHandler = { [weak self](image, url, error) in
                    guard let weakSelf = self else{
                        return
                    }
                    if let newImage = image, let unwrappedUrl = url {
                        weakSelf.cache.setObject(newImage, forKey: unwrappedUrl as NSString)
                    }
                    DispatchQueue.main.async {
                        completionHandler(image, url, error)
                    }
                }
                operation.queuePriority = .high
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    func slowDownImageDownLoadTask(url: String){
        guard let imageUrl = URL(string : url) else{
            return
        }
        
        if let operation = imageDownloadQueue.operations.filter({ (obj) -> Bool in
            if let imageTask = obj as? ImageDownloadOperation{
                return imageTask.imageUrl == imageUrl && imageTask.state == .executing
            }
            return false
        }).first{
            operation.queuePriority = .low
        }
    }
}

