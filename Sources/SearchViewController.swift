//
//  SearchViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/17.
//

import UIKit
import Alamofire
import CoreLocation

class SearchViewController: UITableViewController {
    @IBOutlet weak var warningVIew: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    
    var searchBar: UISearchBar? {
        didSet {
            searchBar?.delegate = self
        }
    }

    var searchResult: SearchResult?
    var flag: String = ""
    var centerLon: Float = 0
    var centerLat: Float = 0
    var pois: [Poi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.tableView)
        navigationBarSetting()
        searchBarUISetting()
        initUI()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar?.resignFirstResponder()
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        print("지도에서 선택 버튼 클릭")
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        svc.flag = self.flag
        self.navigationController?.pushViewController(svc, animated: true)
    }
    
    
    // UserDefaults에서 검색어 목록을 불러오는 함수
    func loadSearchHistory() -> [Poi] {
        guard let data = UserDefaults.standard.data(forKey: "SearchHistory"),
              let searchList = try? JSONDecoder().decode([Poi].self, from: data) else {
            return [Poi]()
        }
        return searchList
    }

    // UserDefaults에 검색어를 저장하는 함수
    func saveSearchHistory(_ searchKeyword: Poi) {
        // UserDefaults에서 검색어 목록을 불러옵니다.
        var searchList = loadSearchHistory()

        // 검색어를 검색어 목록에 추가합니다.
        searchList.insert(searchKeyword, at: 0)
        
        // 최근 10개의 검색어만 저장합니다.
        if searchList.count > 10 {
            searchList.removeLast()
        }
        
        // 검색어 목록을 UserDefaults에 저장합니다.
        guard let data = try? JSONEncoder().encode(searchList) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "SearchHistory")
        
        // 테이블 뷰를 업데이트합니다.
        self.tableView.reloadData()
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
        let searchBar = UISearchBar()
        searchBar.placeholder = "\(self.flag) 입력"
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
        self.searchBar = searchBar
    }
    
    func searchBarUISetting() {
        searchBar?.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    }
    
    func searchFor(query: String) {
        let parameters: [String: Any] = [
            "version": 1,
            "searchKeyword": query,
            "searchtypCd": "A",
            "radius": "0",
            "centerLon": self.centerLon,
            "centerLat": self.centerLat,
            "appKey": "jztJUPbn8ba0rJkDt8YPZ3BNreZjkzkR34COlvQD"
        ]
        
        AF.request("https://apis.openapi.sk.com/tmap/pois", method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                print("호출 성공")
                if JSONSerialization.isValidJSONObject(data) {
                    do {
                        let searchPoiInfo = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let json = try JSONDecoder().decode(SearchResult.self, from: searchPoiInfo)
                        self.searchResult = json
            
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.reloadData()
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
        if let searchResult = self.searchResult {
            return searchResult.searchPoiInfo.pois.poi.count ?? 0
        } else {
            return loadSearchHistory().count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        if let searchResult = self.searchResult {
            let poi = searchResult.searchPoiInfo.pois.poi[indexPath.row]
            cell.nameLabel.text = poi.name
            cell.addressLabel.text = poi.newAddressList.newAddress[0].fullAddressRoad
            var distance = Double(poi.radius) ?? 0.0
            distance = distance * 1000
            if distance < 1000 {
                cell.distLabel.text = "\(distance) m"
            } else {
                cell.distLabel.text = "\(distance/1000) km"
            }
        } else {
            let searchResult = loadSearchHistory()[indexPath.row]
            print(searchResult.name)
            cell.nameLabel.text = searchResult.name
            cell.addressLabel.text = searchResult.newAddressList.newAddress[0].fullAddressRoad
            cell.distLabel.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        guard let searchResult = searchResult?.searchPoiInfo.pois.poi[indexPath.row] else { return }
        // UserHistory에 저장
        saveSearchHistory(searchResult)
        svc.centerLon = Double(searchResult.noorLon)
        svc.centerLat = Double(searchResult.noorLat)
        svc.flag = self.flag
        self.navigationController?.pushViewController(svc, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(query: searchText)
    }
    
}
