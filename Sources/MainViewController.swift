//
//  MainViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/10.
//

import UIKit
import NMapsMap
import CoreLocation

class MainViewController: UIViewController {
    @IBOutlet weak var mapView: NMFMapView! /// 네이버 맵 지도 View
    @IBOutlet weak var nextButton: UIButton! /// 다음 화면으로 이동하는 버튼
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        /// 지도 유형 설정
        setMapSetting()
        buttonSetting()
        /// 지도 View를 맨 뒤로 배치
        self.view.sendSubviewToBack(mapView)
        
    }
    
    private func buttonSetting() {
        self.nextButton.layer.cornerRadius = 5
    }
    
    
    private func setMapSetting() {
        mapView.mapType = .basic
        /// 건물그룹, 대중교통그룹 활성화
        mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        /// 실내지도 허용
        mapView.isIndoorMapEnabled = true
        /// 로고 위치 조정
        mapView.logoAlign = .rightTop
        
        
    }
}
