////
////  TMapAPITests.swift
////  PathFinderTests
////
////  Created by tmoney on 2023/03/29.
////
//
//import XCTest
//@testable import PathFinder
//
//class TMapAPITests: XCTestCase {
//
//    func testSearchPOI_withValidKeyword_shouldReturnPOIList() {
//        let expectation = self.expectation(description: "SearchPOI")
//        let keyword = "서울역"
//        TMapAPI.shared.searchPOI(withKeyword: keyword) { result in
//            switch result {
//            case .success(let poiList):
//                XCTAssertNotNil(poiList)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Unexpected error: \(error)")
//            }
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testSearchPOI_withInvalidKeyword_shouldReturnError() {
//        let expectation = self.expectation(description: "SearchPOI")
//        let keyword = ""
//        TMapAPI.shared.searchPOI(withKeyword: keyword) { result in
//            switch result {
//            case .success(_):
//                XCTFail("Expected error but received success")
//            case .failure(let error):
//                XCTAssertEqual(error, .invalidKeyword)
//                expectation.fulfill()
//            }
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//}
