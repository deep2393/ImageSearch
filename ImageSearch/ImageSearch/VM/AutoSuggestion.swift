//
//  File.swift
//  ImageSearch
//
//  Created by Deepak Singh on 06/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//
import Foundation

class AutoSuggestionVM: AutoSuggestionVMProtocol{
    var autoSuggestionDBHandler : AutoSuggestionDBProtocol
    var models : [AutoSuggestionModelProtocol]{
        return autoSuggestionDBHandler.getAllModels()
    }
    
    //MARK:- init
    init() {
        autoSuggestionDBHandler = AutoSuggestionDBHandler()
    }
    
    //MARK:- model confirmation
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



class AutoSuggestionDBHandler: AutoSuggestionDBProtocol{
    let kAutoSuggestionKey = "AutoSuggestion"
    var autoSuggestionArr : [AutoSuggestionModelProtocol]
    let kMaxCount : Int = 10
    
    init() {
        autoSuggestionArr = []
        if let stringArr = UserDefaults.standard.stringArray(forKey: kAutoSuggestionKey){
            for obj in stringArr{
                autoSuggestionArr.append(ImageAutoSuggestionModel(text: obj))
            }
        }
    }
    
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
        
        UserDefaults.standard.set(stringArr, forKey: kAutoSuggestionKey)
        UserDefaults.standard.synchronize()
    }
}
