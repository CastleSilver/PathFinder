//
//  SearchViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/17.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var warningVIew: UIView!
    
    var searchResults: [SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.tableView)
        navigationBarSetting()
        let nib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchResultCell")

    }
    
    func navigationBarSetting() {
        // navigationBar hidden 속성 해제
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .white
        // search bar
        // 버튼 종류에 따라 출발지/도착지 구분 필요
        let searchBar = UISearchBar()
        searchBar.placeholder = "출발지 입력"
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarUISetting() {
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    }
    
//    private func searchFor(query: String) {
//        let parameters: [String: Any] = [
//            "version": "1",
//            "searchKeyword": query,
//            "areaLLCode": "11",
//            "areaLMCode": "000",
//            "resCoordType": "KATECH",
//            "searchType": "name",
//            "searchtypCd": "A",
//            "radius": "0",
//            "reqCoordType": "KATECH",
//            "multiPoint": "Y",
//            "appKey": "jztJUPbn8ba0rJkDt8YPZ3BNreZjkzkR34COlvQD"
//        ]
//
//        AF.request("https://apis.openapi.sk.com/tmap/pois", method: .get, parameters: parameters).responseJSON { [weak self] response in
//            switch response.result {
//            case .success(let json):
//                if let response = json as? [String: Any],
//                   let searchPoiInfo = response["searchPoiInfo"] as? [String: Any],
//                   let pois = searchPoiInfo["pois"] as? [[String: Any]] {
//
//                    let searchResults = pois.compactMap { SearchResult(json: $0) }
//
//                    DispatchQueue.main.async {
//                        self?.searchResults = searchResults
//                        self?.tableView.reloadData()
//                        self?.noResultsLabel.isHidden = !searchResults.isEmpty
//                    }
//                }
//
//            case .failure(let error):
//                print("Error searching for location: \(error.localizedDescription)")
//            }
//        }
//    }
    
    @objc func searchBarDidChange(_sender: Any?) {
        var keyword = self.searchBar.searchTextField.text
    }
}

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.name
        cell.detailTextLabel?.text = searchResult.upperAddrName + " " + searchResult.middleAddrName + " " + searchResult.roadName + " " + searchResult.firstBuildNo
        
        if searchResult.secondBuildNo != "" {
            cell.detailTextLabel?.text! += "-" + searchResult.secondBuildNo
        }
        
        return cell
    }
}
