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
    var timer = Timer()
    var countPassed = 0//test
 
    var mainView = FindTotalView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItems()
        
        self.dataSource = self
        
        let vc1 = NearViewController()
        vc1.setCoordinate(lat: lat, long: long)
        let vc2 = ReceivedRequestViewController()
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
        
        let systemBar = bar.systemBar()
        systemBar.backgroundStyle = .flat(color: .white)
        
        // Add to view
        addBar(systemBar, dataSource: self, at: .top)
                
        //1번째 탭
        scrollToPage(.at(index: 0), animated: false)
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateBy5Sec), userInfo: nil, repeats: true)
}
    
    func configureNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopSearchBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.font(.Title3_M14) ], for: .normal)
        navigationItem.title = "새싹 찾기"
    }
    
    @objc func updateBy5Sec() {
        countPassed += 1//test
        print(countPassed)//test
        
        checkMatchStatusby5Sec()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func backBtnClicked() {
        checkCurrentStatus()
    }
    
    func checkCurrentStatus() {
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIMyQueueStatusCode.success.rawValue:
                self.navigationController?.popViewController(animated: true)
                return
            case APIMyQueueStatusCode.noSearch.rawValue: //일반상태가 해당 VC에 올 일이 없음.
                return
            case APIMyQueueStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.checkCurrentStatus()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIMyQueueStatusCode.serverError.rawValue, APIMyQueueStatusCode.clientError.rawValue:
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
                var vcList = self.navigationController!.viewControllers
                for i in 0 ..< vcList.count {//NoNetwork, TabBar, Search, FindTotal
                    if vcList[i].isKind(of: MainMapViewController.self) {
                        (vcList[i] as! MainMapViewController).moveToUserLocation()
                        break
                    }
                }
                self.navigationController?.popViewController(animated: true)
                return
            case APIStopStudyStatusCode.matched.rawValue: //매칭 상태로 새싹 찾기는 이미 중단된 상태
                self.showToast(message: "누군가와 스터디를 함께하기로 약속하셨어요!")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.checkMatchStatusby5Sec()
                })
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
    
    func checkMatchStatusby5Sec() {
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIMyQueueStatusCode.success.rawValue:
                if myQueueState?.matched == 1 {
                    self.showToast(message: "\(myQueueState?.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        let vc = ChattingViewController()
                        self.transition(vc, transitionStyle: .push)
                    })
                }
                return
            case APIMyQueueStatusCode.noSearch.rawValue: //일반상태
                return
            case APIMyQueueStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.checkMatchStatusby5Sec()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIMyQueueStatusCode.serverError.rawValue, APIMyQueueStatusCode.clientError.rawValue:
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
        self.navigationController?.navigationBar.isHidden = false
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
