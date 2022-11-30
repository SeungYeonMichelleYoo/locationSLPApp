//
//  MainMapViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//

import UIKit
import MapKit
import CoreLocation //위치 권한 설정

final class MainMapViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var viewModel = HomeViewModel()
    var mainView = MainMapView()
    var gender = 0
    var emailAddress = ""
    var phoneNumber = ""
    var FCMtoken = ""
    
    //2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734) //새싹 영등포캠퍼스(디폴트)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //3. 프로토콜 연결
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
        navigationItem.title = ""
        
        //지도 중심 잡기
        let center = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        setRegionAndAnnotation(center: center)
        
        //플로팅버튼 상태
        checkCurrentStatus()
        
        mainView.floatingBtn.addTarget(self, action: #selector(floatingBtnClicked), for: .touchUpInside)
    }
    
    @objc func floatingBtnClicked() {
        if mainView.floatingBtn.imageView?.image == UIImage(named: "floatingBtn_waiting") {
            //새싹찾기 화면으로 이동
        } else if mainView.floatingBtn.imageView?.image == UIImage(named: "floatingBtn_matched") {
            //채팅화면으로 이동
            let vc = ChattingViewController()
            self.transition(vc, transitionStyle: .push)
        } else if mainView.floatingBtn.imageView?.image == UIImage(named: "floatingBtn_search") {
            let authorizationStatus: CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                authorizationStatus = locationManager.authorizationStatus
            } else {
                authorizationStatus = CLLocationManager.authorizationStatus()
            }
            switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                let vc = SearchViewController()
                var center = mainView.mapView.centerCoordinate
                vc.lat = center.latitude
                vc.long = center.longitude
                self.transition(vc, transitionStyle: .push)
                return
            default:
                return
            }
        }
    }
    
    func checkCurrentStatus() {
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                if myQueueState?.matched == 0 {
                    self.mainView.floatingBtn.setImage(UIImage(named: "floatingBtn_waiting"), for: .normal)
                } else {
                    self.mainView.floatingBtn.setImage(UIImage(named: "floatingBtn_matched"), for: .normal)
                }
                return
            case APIStatusCode.option.rawValue:
                print("일반상태")
                self.mainView.floatingBtn.setImage(UIImage(named: "floatingBtn_search"), for: .normal)
                return
            case APIStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                if isSuccess! {
                    self.checkCurrentStatus()
                } else {
                    self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                }
            }
                return
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        //지도 중심 기반으로 보여질 범위
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(region, animated: true)
        //annotation 핀 고정
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mainView.mapView.addAnnotation(annotation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //재사용 할 수 있는 커스텀어노테이션
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
       
        var annotationView = self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
            annotationView?.canShowCallout = true
            
            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
            miniButton.tintColor = .blue
            annotationView?.rightCalloutAccessoryView = miniButton
        
        } else {
        
            annotationView?.annotation = annotation
        }

        annotationView?.image = UIImage(named: "centerpin")
        
        return annotationView
    }
    
}

//MARK: - 위치 관련된 User Defined 메서드
extension MainMapViewController {
    //7. iOS버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    //위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져있다면 커스텀 얼럿으로 상황 알려주기
    func checkUserDeviceLocationsServiceAuthorization() {
        //위치에 대한 권한 종류
        //CLAuthorizationStatus
        //-denied: 허용 안함/ 설정에서 추후에 거부/ 위치 서비스 중지/ 비행기 모드
        //-restricted: 앱 권한 자체 없는 경우/ 자녀 보호 기능 같은걸로 아예 제한
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크: locationServiceEnabled()
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함.
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    //8. 사용자의 위치권한 상태 확인
    //사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인(단, 사전에 iOS위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            
            let region = MKCoordinateRegion(center: defaultCoordinate, latitudinalMeters: 700, longitudinalMeters: 700)
            mainView.mapView.setRegion(region, animated: true)
            
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation()
            
        default: print("DEFAULT")
        }
    }
    
    //MARK: - 위치 권한 허용 팝업
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "안내", message: "위치 서비스 사용 불가", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한번도 설정앱에 들어가지 않았거나, 막 다운 받은 앱이거나
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler: { _ in
            //새싹캠퍼스를 중심으로 서버통신
            self.nearbySearch(lat: 37.517819364682694, long: 126.88647317074734)
        })
            
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
            
        self.present(requestLocationServiceAlert, animated: true, completion: nil)
    }
 
    func nearbySearch(lat: Double, long: Double) {
        self.viewModel.nearbySearchVM(lat: lat, long: long) { searchModel, statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                print("스터디 함께할 새싹 검색 성공")
                return
            case APIStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.nearbySearch(lat: lat, long: long)
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
                
            case APIStatusCode.unAuthorized.rawValue:
                print("미가입회원")
                return
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    //MARK: - 현재위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
            mainView.mapView.setRegion(region, animated: true)
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationsServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}
