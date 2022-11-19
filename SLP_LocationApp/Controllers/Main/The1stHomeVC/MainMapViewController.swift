//
//  MainMapViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//

import UIKit
import MapKit
import CoreLocation //위치 권한 설정

class MainMapViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mainView = MainMapView()
    var gender = 0
    var emailAddress = ""
    var phoneNumber = ""
    var FCMtoken = ""
    
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    
    //2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //3. 프로토콜 연결
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
        navigationItem.title = ""
        
        //지도 중심 잡기: 애플맵 활용해 좌표 복사
        let center = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        setRegionAndAnnotation(center: center)
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
    
    //MARK: - 위치 권한 허용 팝업
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRequestLocationServiceAlert()
    }
    
    //재사용 할 수 있는 어노테이션 만들기! 마치 테이블뷰의 재사용 Cell을 넣어주는 것과 같아요!
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // 유저 위치를 나타낼때는 기본 파란 그 점 아시죠? 그거 쓰고싶으니까~ 요렇게 해주시고 만약에 쓰고싶은 어노테이션이 있다면 그녀석을 리턴해 주시면 되긋죠? 하하!
            return nil
        }
        //우리가 만들고 싶은 커스텀 어노테이션을 만들어 줍시다. 그냥 뿅 생길 수 없겠죠? 보여주고 싶은 모양을 뷰로 짜준다고 생각하시면 됩니다.
        //즉시 인스턴스로 만들어 줘 보겠습니다요. 어떻게 생겼을지는 아직 안정했지만 일단 커스텀이라는 식별자?를 가진 뷰로 만들어 줬습니다.
        //마커 어노테이션뷰 라는 어노테이션뷰를 상속받는 뷰가 따로있습니다. 풍선모양이라고 하는데 한번 만들어 보시는것도 좋겠네요! 테두리가 있고 안에 내용물을 바꾸는 식으로 설정이 되는듯 해요.
        var annotationView = self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            //없으면 하나 만들어 주시고
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
            annotationView?.canShowCallout = true
            
            
            //callOutView를 통해서 추가적인 액션을 더해줄수도 있겠죠! 와 무지 간편합니다!
            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
            miniButton.tintColor = .blue
            annotationView?.rightCalloutAccessoryView = miniButton
            
        } else {
            //있으면 등록된 걸 쓰시면 됩니다.
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "centerpin")
        
        //상황에 따라 다른 annotationView를 리턴하게 하면 여러가지 모양을 쓸 수도 있겠죠?
        
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
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = defaultCoordinate
            annotation.title = "이곳은 청년취업사관학교입니다."
            
            //지도에 핀 추가
            mainView.mapView.addAnnotation(annotation)
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation()
            
        default: print("DEFAULT")
        }
    }
    
    //MARK: - 위치 권한 허용 팝업
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한번도 설정앱에 들어가지 않았거나, 막 다운 받은 앱이거나
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler: { _ in
            print("취소")
        })
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
    //MARK: - 현재위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
            mainView.mapView.setRegion(region, animated: true)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationsServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}
