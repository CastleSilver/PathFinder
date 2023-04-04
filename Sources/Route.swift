//
//  Route.swift
//  PathFinder
//
//  Created by tmoney on 2023/04/03.
//

import Foundation

struct Route: Codable {
    static let shared = Route()
    private init() {}
    
    var startAddress: String = ""
    var startLon: Double = 0
    var startLat: Double = 0
    var arrivalAddress: String = ""
    var arrivalLon: Double = 0
    var arrivalLat: Double = 0
}
