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
    var latArr:[String] = [] //var latArr = [String]() 과의 차이??
    var longArr:[String] = []
    var opponentList:[OpponentModel] = []
    var receivedList:[OpponentModel] = []
    var lat = 0.0
    var long = 0.0
    var isCoordinateSet = false
    
    lazy var locationManager : CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734) //새싹 영등포캠퍼스(디폴트)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
        navigationItem.title = ""
                
        mainView.floatingBtn.addTarget(self, action: #selector(floatingBtnClicked), for: .touchUpInside)
        
        mainView.currentlocationBtn.addTarget(self, action: #selector(currentBtnClicked), for: .touchUpInside)
    }
    
    //현재 위치 버튼 클릭시
    @objc func currentBtnClicked() {
        mainView.mapView.showsUserLocation = false //파란점
        mainView.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func floatingBtnClicked() {
        if mainView.floatingBtn.imageView?.image == UIImage(named: "floatingBtn_waiting") {
            //새싹찾기 화면으로 이동
            let vc = FindTotalViewController()
            var center = mainView.mapView.centerCoordinate
            vc.lat = center.latitude
            vc.long = center.longitude
            self.transition(vc, transitionStyle: .push)
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
                //스터디 입력 화면으로 이동
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
    
    //현재 상태에 따른 플로팅버튼
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
    
    public func moveToUserLocation() {
        mainView.mapView.setCenter(defaultCoordinate, animated: false)
        //mainView.mapView.userLocation.coordinate로 바꾸기 나중에
    }
    
    func centerMap(center: CLLocationCoordinate2D) {
        //지도 중심 기반으로 보여질 범위 (annotation기준으로 반경 약 700m)
        //중요!!!!!!!!!!!!!!!! 나중에 center 다시 defaultCoordinate -> center로 바꿔놓기
        let region = MKCoordinateRegion(center: defaultCoordinate, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(region, animated: true)
        
        nearbySearch(lat: defaultCoordinate.latitude, long: defaultCoordinate.longitude) //center.latitude,~로 나중에 바꾸기!!!!!!!!!!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        checkUserDeviceLocationsServiceAuthorization()
        checkCurrentStatus()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        var annotationView = self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage: UIImage!
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        
        sesacImage = SesacFace.image(level: annotation.sesac_image!)
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
        
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mainView.mapView.isUserInteractionEnabled = false
        mapView.annotations.forEach {
          if !($0 is MKUserLocation) {
            mapView.removeAnnotation($0)
          }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800), execute: {
            self.mainView.mapView.isUserInteractionEnabled =  true
        })
        nearbySearch(lat: mapView.region.center.latitude, long: mapView.region.center.longitude)
    }
}

//MARK: - 위치 관련된 User Defined 메서드
extension MainMapViewController {
    //iOS버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
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
        
        //iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함.
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    //사용자의 위치권한 상태 확인 (위치 가져오기)
    //사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인(단, 사전에 iOS위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        print("checkUserCurrentLocationAuthorization called")
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            self.isCoordinateSet = true
            self.centerMap(center: defaultCoordinate)
            //여기서 영등포중심으로 서버통신 진행(post, v1/queue/search)
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
            self.isCoordinateSet = true
            self.centerMap(center: self.defaultCoordinate)
        })
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        self.present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
    //주변 새싹 annotations
    private func nearbySearch(lat: Double, long: Double) {
        print("lat: \(lat), long: \(long)")
        self.viewModel.nearbySearchVM(lat: lat, long: long) { searchModel, statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                print("스터디 함께할 새싹 검색 성공")
                self.opponentList = searchModel!.fromQueueDB
                self.receivedList = searchModel!.fromQueueDBRequested
                for opponent in self.opponentList {
                    print("opponent.lat: \(opponent.lat)")
                    let pin = CustomAnnotation(sesac_image: opponent.sesac, coordinate: CLLocationCoordinate2D(latitude: opponent.lat, longitude: opponent.long))
                    self.mainView.mapView.addAnnotation(pin)
                }
                for received in self.receivedList {
                    let receivedPin = CustomAnnotation(sesac_image: received.sesac, coordinate: CLLocationCoordinate2D(latitude: received.lat, longitude: received.long))
                    self.mainView.mapView.addAnnotation(receivedPin)
                }
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
        if !isCoordinateSet {
            if let coordinate = locations.last?.coordinate {
                isCoordinateSet = true
                centerMap(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationsServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}

