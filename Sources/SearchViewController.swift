//
//  SearchViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/17.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController {
    @IBOutlet weak var warningVIew: UIView!
    var searchBar: UISearchBar? {
        didSet {
            searchBar?.delegate = self
        }
    }
    
    var searchResult: SearchResult?
    var pois: [Poi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.tableView)
        navigationBarSetting()
        searchBarUISetting()
        initUI()
    }
    
    
    func initUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        self.searchBar = searchBar
    }
    
    func searchBarUISetting() {
        searchBar?.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    }
    
    private func searchFor(query: String) {
        let parameters: [String: Any] = [
            "version": "1",
            "searchKeyword": query,
            "areaLLCode": "11",
            "areaLMCode": "000",
            "resCoordType": "KATECH",
            "searchType": "name",
            "searchtypCd": "A",
            "radius": "0",
            "reqCoordType": "KATECH",
            "multiPoint": "Y",
            "appKey": "jztJUPbn8ba0rJkDt8YPZ3BNreZjkzkR34COlvQD"
        ]
        
        
        AF.request("https://apis.openapi.sk.com/tmap/pois", method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if JSONSerialization.isValidJSONObject(data) {
                    do {
                        print("호출 성공")
                        let searchPoiInfo = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let json = try JSONDecoder().decode(SearchResult.self, from: searchPoiInfo)
                        self.searchResult = json
                        DispatchQueue.main.async { [self] in
                            self.tableView.reloadData()
//                            self.warningVIew.isHidden = !json.isEmp
                        }
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
                
            case .failure(let error):
                print("Error searching for location: \(error.localizedDescription)")
            }
        }
        
    }
}

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.searchPoiInfo.pois.poi.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        let searchResult = searchResult?.searchPoiInfo.pois.poi[indexPath.row]
        cell.nameLabel.text = searchResult?.name
        cell.addressLabel.text = searchResult?.newAddressList.newAddress[0].fullAddressRoad
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("키보드 변화")
        searchFor(query: searchText)
    }
    
}

