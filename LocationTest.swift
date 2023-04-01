//
//  LocationTest.swift
//  PathFinderTests
//
//  Created by tmoney on 2023/03/29.
//

import XCTest
import CoreLocation

@testable import PathFinder

class LocationTest: XCTestCase {
    var locationManager: CLLocationManager!

    override func setUpWithError() throws {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        XCTFail()
    }

    override func tearDownWithError() throws {
        locationManager = nil
    }

    // 현재 위치 정보가 nil인지 아닌지 확인
    func testGetCurrentLocation() throws {
        var currentLocation: CLLocation?

        let expectation = XCTestExpectation(description: "get location")
        locationManager.requestLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if let location = self.locationManager.location {
                currentLocation = location
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(currentLocation)
    }
}
