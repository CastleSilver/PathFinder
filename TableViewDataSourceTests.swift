//
//  TableViewDataSourceTests.swift
//  PathFinderTests
//
//  Created by tmoney on 2023/03/29.
//

import XCTest
@testable import PathFinder

final class TableViewDataSourceTests: XCTestCase {

    var tableViewDataSource: SearchViewController!

        var tableView: UITableView!

        override func setUp() {
            super.setUp()
            tableViewDataSource = SearchViewController()
            tableView = UITableView()
            tableView.dataSource = tableViewDataSource
        }

        func testTableViewDataSource_numberOfRowsInSection() {
            tableViewDataSource.searchResults = [
                SearchResult(name: "POI1", upperAddrName: "Address1", middleAddrName: "middle1", roadName: "road1", firstBuildNo: "1", secondBuildNo: "1"),
                SearchResult(name: "POI2", upperAddrName: "Address2", middleAddrName: "middle2", roadName: "road2", firstBuildNo: "2", secondBuildNo: "2"),
                SearchResult(name: "POI3", upperAddrName: "Address3", middleAddrName: "middle3", roadName: "road3", firstBuildNo: "3", secondBuildNo: "3")
            ]
            let numberOfRows = tableViewDataSource.tableView(tableView, numberOfRowsInSection: 0)
            XCTAssertEqual(numberOfRows, 3)
        }

        func testTableViewDataSource_cellForRowAt() {
            tableViewDataSource.searchResults = [
                SearchResult(name: "POI1", upperAddrName: "Address1", middleAddrName: "middle1", roadName: "road1", firstBuildNo: "1", secondBuildNo: "1")
            ]
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableViewDataSource.tableView(tableView, cellForRowAt: indexPath) as? SearchResultCell
            XCTAssertEqual(cell?.nameLabel.text, "POI1")
            XCTAssertEqual(cell?.addressLabel.text, "Address1")
        }

}
