//
//  ImageSearchVMTest.swift
//  ImageSearchTests
//
//  Created by Deepak Singh on 07/06/20.
//  Copyright © 2020 Deepak Singh. All rights reserved.
//

import XCTest

class ImageSearchVMTest: XCTestCase {

    //MARK:- variables
    var sut: ImageSearchVM!
    
    
    //MARK:- life cycle
    override func setUpWithError() throws {
        let mockApiHandler = MockApiHandler()
        sut = ImageSearchVM(dataModels: [], apiHandler: mockApiHandler)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    //MARK:- custom test methods
    func testFetchModelsSuccess(){
        //success case
        sut.fetchModels(searchText: "Test")
        XCTAssertEqual(sut.dataModels[0].imageUrl, "Test1", "Invalid url")
    }
    
    func testFetchModelsEmpty(){
        //fail case
        sut.fetchModels(searchText: "Test1") //no objects for this test
         XCTAssertEqual(sut.dataModels.isEmpty, true, "Object count different")
    }
    
    func testRowCount(){
        sut.fetchModels(searchText: "Test")
        XCTAssertEqual(sut.rowCount, 4, "Object count different")
    }
    
    func testGetModel(){
        sut.fetchModels(searchText: "Test")
        XCTAssertEqual(sut.getModel(index: 3)?.imageUrl, "Test4", "Different object than expected")
        XCTAssertNil(sut.getModel(index: 5), "Nil object for wrong index")
    }
}
