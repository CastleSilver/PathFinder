//
//  POI.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/28.
//

import Foundation

struct SearchResult: Codable {
    let searchPoiInfo: SearchPoiInfo
}

// MARK: - SearchPoiInfo
struct SearchPoiInfo: Codable {
    let totalCount, count, page: String
    let pois: Pois
}

// MARK: - Pois
struct Pois: Codable {
    let poi: [Poi]
}

// MARK: - Poi
struct Poi: Codable {
    let id, pkey, navSeq, collectionType: String
    let name, telNo, frontLat, frontLon: String
    let noorLat, noorLon, upperAddrName, middleAddrName: String
    let lowerAddrName, detailAddrName, mlClass, firstNo: String
    let secondNo, roadName, firstBuildNo, secondBuildNo: String
    let radius, bizName, upperBizName, middleBizName: String
    let lowerBizName, detailBizName, rpFlag, parkFlag: String
    let detailInfoFlag, desc, dataKind, zipCode: String
    let adminDongCode, legalDongCode: String
    let newAddressList: NewAddressList
}

// MARK: - NewAddressList
struct NewAddressList: Codable {
    let newAddress: [NewAddress]
}

// MARK: - NewAddress
struct NewAddress: Codable {
    let centerLat, centerLon, frontLat, frontLon: String
    let roadName, bldNo1, bldNo2, roadID: String
    let fullAddressRoad: String

    enum CodingKeys: String, CodingKey {
        case centerLat, centerLon, frontLat, frontLon, roadName, bldNo1, bldNo2
        case roadID = "roadId"
        case fullAddressRoad
    }
}
