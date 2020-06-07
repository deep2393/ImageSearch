//
//  MockModels.swift
//  ImageSearchTests
//
//  Created by Deepak Singh on 07/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import Foundation

class MockUserDefault: UserDefaultMockProtocol{
    private var dataStore = [String: Any]()
    
    func set(_ items: Any?, forKey: String) {
        dataStore[forKey] = items
    }
    
    func stringArray(forKey: String) -> [String]? {
        if let items = dataStore[forKey] as? [String]?{
            return items
        }
        return nil
    }
    
    func synchronize() -> Bool {
        return true
    }
}
