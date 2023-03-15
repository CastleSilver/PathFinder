//
//  MainViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/10.
//

import UIKit
import NMapsMap

class MainViewController: UIViewController {
    // 네이버 맵 지도 View
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var belowView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var arrivalView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지도 유형 설정
        setMapSetting()
        buttonSetting()
    }
    
    private func buttonSetting() {
        self.nextButton.layer.cornerRadius = 5
    }
    
    
    private func setMapSetting() {
        self.mapView.mapType = .basic
        // 건물그룹, 대중교통그룹 활성화
        self.mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        self.mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        // 실내지도 허용
        self.mapView.isIndoorMapEnabled = true
    }
}
