//
//  AutoSuggestVMtests.swift
//  ImageSearchTests
//
//  Created by Deepak Singh on 07/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import XCTest

class AutoSuggestVMtests: XCTestCase {
    //MARK:- variables
    var sut : AutoSuggestionVM!
    
    //MARK:- life cycle
    override func setUpWithError() throws {
        let mockDBHandler = MockUserDefault()
        let autoSuggestDBHandler = AutoSuggestionDBHandler(userDefault: mockDBHandler)
       sut = AutoSuggestionVM(dbHandler: autoSuggestDBHandler)
    }

    override func tearDownWithError() throws {
       sut = nil
    }
    
    //MARK:- custom test methods
    func testDataSourceEmptyCheck(){
        XCTAssertEqual(sut.isDataSourceEmpty, true, "Invalid bool state")
        sut.saveModel(text: "Test")
        XCTAssertEqual(sut.isDataSourceEmpty, false, "Invalid bool state")
    }
    
    func testModelCount(){
        XCTAssertEqual(sut.modelCount, 0, "Invalid item number")
        sut.saveModel(text: "Test")
        sut.saveModel(text: "Test2")
        XCTAssertEqual(sut.modelCount, 2, "Invalid item state")
    }
    
    func testGetModel(){
        XCTAssertNil(sut.getModel(index: 0), "Invalid model returned")
        sut.saveModel(text: "Test")
        XCTAssertEqual(sut.getModel(index: 0)?.text, "Test", "Invalid model")
    }
    
    func testSaveModelMethod(){
        sut.saveModel(text: "Test")
        sut.saveModel(text: "Test2")
        
        //new items should insert at 0
        XCTAssertEqual(sut.getModel(index: 0)?.text, "Test2", "Invalid model")
        XCTAssertEqual(sut.getModel(index: 1)?.text, "Test", "Invalid model")
    }
    
}
