//
//  MainViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/10.
//

import UIKit
import NMapsMap
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: NMFMapView! /// 네이버 맵 지도 View
    @IBOutlet weak var nextButton: UIButton! /// 다음 화면으로 이동하는 버튼
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var arrivalButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var mylocationMarker: NMFMarker? // 내 위치 마커
    var startMarker: NMFMarker? // 출발 위치 마커
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        mapView.delegate = self
        locationManager.delegate = self
        checkLocationAuthorization()
        /// 지도 유형 설정
        setMapSetting()
        buttonSetting()
    }
    
    // MARK: - Action Methods
    @IBAction func StartTabButton(_ sender: Any) {
        print("다음 버튼 클릭")
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") else { return }
        svc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(svc, animated: true)
    }
    
    @IBAction func LocationButtonTapped(_ sender: Any) {
        print("내 위치 재조정")
        locationButton.isEnabled = false
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Methods
    @objc func mapViewIdle(_ mapView: NMFMapView) {
        addStartMarker() // 지도 이동이 멈추면 'startMarker' 마커 추가
    }
    
    func addStartMarker() {
        guard let center = mapView?.cameraPosition.target else {
            return
        }
        startMarker?.mapView = nil
        
        let latitude = center.lat
        let longitude = center.lng
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let image = UIImage(named: "start_marker")
        let overlayImage = NMFOverlayImage(image: image!)
        self.startMarker = NMFMarker(position: NMGLatLng(lat: latitude, lng: longitude), iconImage: overlayImage)
        self.startMarker?.width = 50
        self.startMarker?.height = 66
        self.startMarker?.mapView = mapView

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            if let error = error {
                print("Reverse geocoder error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemark")
                return
            }
            
            DispatchQueue.main.async {
                self.startLabel.text = placemark.name // 'startLabel'에 주소를 표시
            }
        }
    }
    
    private func buttonSetting() {
        self.nextButton.layer.cornerRadius = 5
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("위치 권한 확인")
            locationManager.startUpdatingLocation()
            setMyLocationMarker()
        case .denied:
            let alertController = UIAlertController(title: "위치 권한 필요", message: "해당 앱에서 위치 권한이 필수입니다. 위치 권한을 허용해주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { (alertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            break
        case .notDetermined:
            print("위치 권한 묻기")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func setMyLocationMarker() {
        if let myLocation = locationManager.location?.coordinate {
            let image = UIImage(named: "my_location")
            let overlayImage = NMFOverlayImage(image: image!)
            self.mylocationMarker = NMFMarker(position: NMGLatLng(lat: myLocation.latitude, lng: myLocation.longitude), iconImage: overlayImage)
            self.mylocationMarker?.mapView = mapView
        }
    }
    
    private func setMapSetting() {
        print("맵 설정")
        mapView.mapType = .basic
        /// 건물그룹, 대중교통그룹 활성화
        mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        /// 실내지도 허용
        mapView.isIndoorMapEnabled = true
        mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        /// 로고 위치 조정
        mapView.logoAlign = .leftTop
        mapView.zoomLevel = 15
        mapView.minZoomLevel = 5
        mapView.maxZoomLevel = 22
    }
    
    // 위치 업데이트 이벤트가 발생할 때 호출되는 델리게이트 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        if let marker = self.mylocationMarker {
            marker.position = NMGLatLng(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude)
        } else {
            let image = UIImage(named: "my_location")
            let overlayImage = NMFOverlayImage(image: image!)
            let marker = NMFMarker(position: NMGLatLng(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude), iconImage: overlayImage)
            marker.mapView = mapView
            self.mylocationMarker = marker
        }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude))
        mapView.moveCamera(cameraUpdate)
        
        locationManager.stopUpdatingLocation()
        locationButton.isEnabled = true
    }
    
}
