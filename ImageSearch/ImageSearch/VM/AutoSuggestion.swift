//
//  File.swift
//  ImageSearch
//
//  Created by Deepak Singh on 06/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//
import Foundation

final class AutoSuggestionVM: AutoSuggestionVMProtocol{
    //MARK:- variables
    var autoSuggestionDBHandler : AutoSuggestionDBProtocol
    private var models : [AutoSuggestionModelProtocol]{
        return autoSuggestionDBHandler.getAllModels()
    }
    
    //MARK:- init
    init(dbHandler: AutoSuggestionDBProtocol = AutoSuggestionDBHandler()) {
        autoSuggestionDBHandler = dbHandler
    }
    
    //MARK:- protocol confirmation
    var isDataSourceEmpty: Bool {
        return models.isEmpty
    }
    
    var modelCount: Int{
        return models.count
    }
    
    func getModel(index: Int) -> AutoSuggestionModelProtocol? {
        if index < modelCount{
            return models[index]
        }
        return nil
    }
    
    func saveModel(text: String) {
        let newModel = ImageAutoSuggestionModel(text: text)
        if !models.contains(where: { (obj) -> Bool in
            return obj.text == newModel.text
        }){
            autoSuggestionDBHandler.saveModel(model: ImageAutoSuggestionModel(text: text))
        }
    }
}



final class AutoSuggestionDBHandler: AutoSuggestionDBProtocol{
    //MARK:- variables
    private let kAutoSuggestionKey = "AutoSuggestion"
    private var autoSuggestionArr : [AutoSuggestionModelProtocol]
    private let kMaxCount : Int = 10
    private let userDefault: UserDefaultMockProtocol
    
    //MARK:- init
    init(userDefault: UserDefaultMockProtocol = UserDefaults.standard) {
        self.userDefault = userDefault
        autoSuggestionArr = []
        if let stringArr = userDefault.stringArray(forKey: kAutoSuggestionKey){
            for obj in stringArr{
                autoSuggestionArr.append(ImageAutoSuggestionModel(text: obj))
            }
        }
    }
    
    //MARK:- protocol methods
    func getAllModels() -> [AutoSuggestionModelProtocol]{
        return autoSuggestionArr
    }
    
    func saveModel(model: AutoSuggestionModelProtocol) {
        autoSuggestionArr.insert(model, at: 0)
        
        if autoSuggestionArr.count > kMaxCount{
            autoSuggestionArr.removeLast()
        }
        
        let stringArr = autoSuggestionArr.compactMap({ (obj) -> String? in
            return obj.text
        })
        
        userDefault.set(stringArr, forKey: kAutoSuggestionKey)
        userDefault.synchronize()
    }
}

extension UserDefaults: UserDefaultMockProtocol{}
