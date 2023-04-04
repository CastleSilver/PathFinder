//
//  MapViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/04/01.
//

import UIKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var setButton: UIButton!
    
    var flag: String = ""
    let locationManager = CLLocationManager()
    var mylocationMarker: NMFMarker?
    var customMarker: NMFMarker?
    var centerLon: Double?
    var centerLat: Double?
    var route = Route.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        setMyLocationMarker()
        setMapSetting()
        navigationBarSetting()
        buttonSetting(flag: flag)
        if flag == "도착지" {
            locationButton.tintColor = UIColor(red: 250/255, green: 106/255, blue: 70/255, alpha: 1)
        }
    }
    
    @IBAction func setButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        // 위치권한 체크하는 코드 추가 필요
        locationManager.startUpdatingLocation()
    }
    
    func buttonSetting(flag: String) {
        // setButton Setting
        setButton.layer.cornerRadius = 15
        var color: UIColor!
        if flag == "출발지" {
            color = UIColor(red: 82/255, green: 190/255, blue: 214/255, alpha: 1)
        } else {
            color = UIColor(red: 250/255, green: 106/255, blue: 70/255, alpha: 1)
        }
        setButton.layer.borderColor = color.cgColor
        setButton.layer.borderWidth = 1
        setButton.setTitle("\(flag)로 설정", for: .normal)
        setButton.setTitleColor(color, for: .normal)
        setButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setButton.clipsToBounds = true
        
        // locationButton Setting
        locationButton.tintColor = color
    }
    
    func navigationBarSetting() {
        // navigationBar hidden 속성 해제
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "\(flag) 설정"
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

extension MapViewController: CLLocationManagerDelegate {
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
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: centerLat ?? currentLocation.coordinate.latitude, lng: centerLon ?? currentLocation.coordinate.longitude))
        mapView.moveCamera(cameraUpdate)
        
        locationButton.isEnabled = true
    }
}

extension MapViewController: NMFMapViewDelegate {
    
    @objc func mapViewIdle(_ mapView: NMFMapView) {
        addCustomMarker() // 지도 이동이 멈추면 'customMarker' 마커 추가
    }
    
    func addCustomMarker() {
        guard let center = mapView?.cameraPosition.target else {
            return
        }
        customMarker?.mapView = nil
        
        let latitude = center.lat
        let longitude = center.lng
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        var image: UIImage!
        if flag == "출발지" {
            image = UIImage(named: "start_marker")
        } else {
            image = UIImage(named: "arrival_marker")
        }
        let overlayImage = NMFOverlayImage(image: image)
        self.customMarker = NMFMarker(position: NMGLatLng(lat: latitude, lng: longitude), iconImage: overlayImage)
        self.customMarker?.width = 50
        self.customMarker?.height = 66
        self.customMarker?.mapView = mapView

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
                self.addressLabel.text = placemark.name // 'addressLabel'에 주소를 표시
                switch self.flag {
                case "출발지":
                    self.route.startAddress = placemark.name ?? ""
                    self.route.startLon = longitude
                    self.route.startLat = latitude
                case "도착지":
                    self.route.arrivalAddress = placemark.name ?? ""
                    self.route.arrivalLat = latitude
                    self.route.arrivalLon = longitude
                default:
                    break
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
