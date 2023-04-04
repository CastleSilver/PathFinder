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
    var route = Route.shared
    var flag: String = "출발지"
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //deprecated된 거 사용 지양
        mapView.delegate = self
        locationManager.delegate = self
        checkLocationAuthorization()
        /// 지도 유형 설정
        setMapSetting()
        buttonSetting()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if arrivalLabel.text != "" {
            nextButton.backgroundColor = UIColor(red: 82/255, green: 190/255, blue: 214/255, alpha: 1)
            nextButton.isEnabled = true
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Action Methods
    @IBAction func nextButtonTapped(_ sender: Any) {
        print("다음 버튼 클릭")
        guard let rvc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else { return }
        guard let start = startLabel.text else { return }
        guard let arrival = arrivalLabel.text else { return }
        print(start)
        rvc.start = start
        rvc.arrival = arrival
        self.navigationController?.pushViewController(rvc, animated: true)
    }

    @IBAction func StartTabButton(_ sender: Any) {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        svc.flag = "출발지"
        svc.centerLat = Float(locationManager.location?.coordinate.latitude ?? 37.5)
        svc.centerLon = Float(locationManager.location?.coordinate.longitude ?? 127)
        self.navigationController?.pushViewController(svc, animated: true)
    }
    
    @IBAction func ArrivalTabButton(_ sender: Any) {
        print("도착 버튼 클릭")
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        svc.flag = "도착지"
        svc.centerLat = Float(locationManager.location?.coordinate.latitude ?? 37.5)
        svc.centerLon = Float(locationManager.location?.coordinate.longitude ?? 127)
        self.navigationController?.pushViewController(svc, animated: true)
    }
    
    @IBAction func LocationButtonTapped(_ sender: Any) {
        print("내 위치 재조정")
        // 위치권한 체크하는 코드 추가 필요
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Methods
    private func buttonSetting() {
        nextButton.layer.cornerRadius = 5
        locationButton.tintColor = UIColor(red: 82/255, green: 190/255, blue: 214/255, alpha: 1)
    }
    
    func setMyLocationMarker() {
        if let myLocation = locationManager.location?.coordinate {
            let image = UIImage(named: "my_location")
            let overlayImage = NMFOverlayImage(image: image!)
            self.mylocationMarker = NMFMarker(position: NMGLatLng(lat: myLocation.latitude, lng: myLocation.longitude), iconImage: overlayImage)
            self.mylocationMarker?.mapView = mapView
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    // 위치 업데이트 이벤트가 발생할 때 호출되는 델리게이트 메서드
    // locationmanager는 클래스로 따로 빼는게 더 좋다
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        
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
        
        locationButton.isEnabled = true
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //always인지 한 번 허용인지에 따라 다르게 처리하기
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
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
        default:
            break
        }
    }
}

extension MainViewController: NMFMapViewDelegate {
    
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
                if let name = placemark.name {
                    self.startLabel.text = name // 'startLabel'에 주소를 표시
                    // 변경된 값 Route 구조체에 저장
                    print("구조체 저장: \(name), \(longitude), \(latitude)")
                    self.route.startAddress = name
                    self.route.startLon = longitude
                    self.route.startLat = latitude
                }
                
            }
        }
    }
    
    private func setMapSetting() {
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
}
