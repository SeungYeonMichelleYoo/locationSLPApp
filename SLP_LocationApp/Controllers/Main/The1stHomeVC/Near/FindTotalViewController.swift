//
//  FindTotalViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import Tabman
import Pageboy
import MapKit
import CoreLocation

class FindTotalViewController: TabmanViewController {
    
    private var viewControllers: [UIViewController] = []
    private var titleList = ["주변 새싹", "받은 요청"]
    var viewModel = HomeViewModel()
    var nearCount: Int = 0
    var opponentList: [OpponentModel] = []
    var receivedList: [OpponentModel] = []
    var lat = 0.0
    var long = 0.0
  
    var mainView = FindTotalView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        var vc1 = NearViewController()
        vc1.setCoordinate(lat: lat, long: long)
        var vc2 = ReceivedRequestViewController()
        vc2.setCoordinate(lat: lat, long: long)
        viewControllers = [vc1, vc2]
        reloadData()
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        
        bar.buttons.customize { (button) in
            button.tintColor = Constants.BaseColor.gray6
            button.selectedTintColor = Constants.BaseColor.green
            button.font = UIFont.font(.Title3_M14)
        }
        bar.indicator.tintColor = Constants.BaseColor.green
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopSearchBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.font(.Title3_M14) ], for: .normal)
       
        
        navigationItem.title = "새싹 찾기"
        //1번째 탭
        scrollToPage(.at(index: 0), animated: false)
}
    @objc func backBtnClicked() {
        checkCurrentStatus()
    }
    
    func checkCurrentStatus() {
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                self.navigationController?.popViewController(animated: true)
                return
            case APIStatusCode.option.rawValue: //일반상태가 해당 VC에 올 일이 없음.
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
    
    @objc func stopSearchBtnClicked() {
        stopStudy()
    }

    private func stopStudy() {
        viewModel.stopStudyVM { myQueue, statusCode in
            switch statusCode {
            case APIStopStudyStatusCode.success.rawValue:
//                var vcList = self.navigationController!.viewControllers
//                var index = 0
//                for vc in vcList {//NoNetwork, TabBar, MainMap, Search, FindTotal
//                    if vc.isKind(of: SearchViewController.self) {
//                        vcList.remove(at: index)
//                        continue
//                    } else if vc.isKind(of: MainMapViewController.self) {
//                        (vc as! MainMapViewController).moveToUserLocation()
//                    }
//                    index = index + 1
//                }
//                self.navigationController!.viewControllers = vcList
                var vcList = self.navigationController!.viewControllers
                for i in 0 ..< vcList.count {//NoNetwork, TabBar, Search, FindTotal
                    if vcList[i].isKind(of: MainMapViewController.self) {
                        (vcList[i] as! MainMapViewController).moveToUserLocation()
                        break
                    }
                }
                self.navigationController?.popViewController(animated: true)
                return
            case APIStopStudyStatusCode.matched.rawValue:
                return
            case APIStopStudyStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.stopStudy()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIStopStudyStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var vcList = self.navigationController!.viewControllers
        for i in 0 ..< vcList.count {//NoNetwork, TabBar, Search, FindTotal
            if vcList[i].isKind(of: SearchViewController.self) {
                vcList.remove(at: i)
                break
            }
        }
        self.navigationController!.viewControllers = vcList
    }
}

extension FindTotalViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = titleList[index]
        return TMBarItem(title: title)
    }
}
