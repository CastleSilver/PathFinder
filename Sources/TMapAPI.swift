//
//  Router.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/28.
//
import Foundation
import Alamofire

class TMapAPI {
    
    func searchPOI(keyword: String, completionHandler: @escaping (Result<SearchResult, Error>) -> Void) {
        // 키보드 값이 입력되면 받아와야 함..
        let keyword = "왕십"
        let baseURL = "https://apis.openapi.sk.com/tmap/pois?version=1&searchKeyword=\(keyword)&areaLLCode=11&areaLMCode=000&resCoordType=KATECH&searchType=name&searchtypCd=A&radius=0&reqCoordType=KATECH&multiPoint=Y&appKey=jztJUPbn8ba0rJkDt8YPZ3BNreZjkzkR34COlvQD"
        
        AF.request(baseURL, method: .get).responseData(completionHandler: { response in
            switch response.result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SearchResult.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
                
            case let .failure(error):
                completionHandler(.failure(error))
            }
        })
        
    }
}
