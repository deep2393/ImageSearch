//
//  CustomOperation.swift
//  ImageSearch
//
//  Created by Deepak Singh on 05/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import Foundation
import UIKit

class AsyncOperation : Operation{
    
    //MARK:- enum for maintaining states
    enum State: String{
        case ready, executing, finished
        var keyPath : String{
            return "is" + rawValue.capitalized
        }
    }
    
    //MARK:- variables
    var state: State = State.ready{
        willSet{
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    //MARK:- overriden variables
    override var isReady: Bool{
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool{
        return state == .executing
    }
    
    override var isFinished: Bool{
        return state == .finished
    }
    
    override var isAsynchronous: Bool{
        return true
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
}

