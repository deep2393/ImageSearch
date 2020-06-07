//
//  AutoSuggestDBTests.swift
//  ImageSearchTests
//
//  Created by Deepak Singh on 07/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import XCTest

class AutoSuggestDBTests: XCTestCase {

    var sut : AutoSuggestionDBHandler!
    
    //MARK:- life cycle
    override func setUpWithError() throws {
        let mockDBHandler = MockUserDefault()
        sut = AutoSuggestionDBHandler(userDefault: mockDBHandler)
    }

    override func tearDownWithError() throws {
       sut = nil
    }
    
    //MARK:- custom test methods
    func testGetAllModels(){
        XCTAssertEqual(sut.getAllModels().count, 0, "Invalid models")
        
        let autoSuggestModel = ImageAutoSuggestionModel(text: "Test")
        sut.saveModel(model: autoSuggestModel)
        
        XCTAssertEqual(sut.getAllModels()[0].text, "Test", "Invalid models")
    }

    
    func testSaveModel(){
        
        let autoSuggestModel = ImageAutoSuggestionModel(text: "Test")
        let autoSuggestModel1 = ImageAutoSuggestionModel(text: "Test1")
        sut.saveModel(model: autoSuggestModel)
        sut.saveModel(model: autoSuggestModel1)
        
        //save should happen by inserting recent item at zero'th position
        XCTAssertEqual(sut.getAllModels()[0].text, "Test1", "Invalid models")
        XCTAssertEqual(sut.getAllModels()[1].text, "Test", "Invalid models")
    }
}
