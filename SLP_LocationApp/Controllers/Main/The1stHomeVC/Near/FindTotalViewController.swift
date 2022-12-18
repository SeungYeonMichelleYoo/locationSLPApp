//
//  FindTotalViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import Tabman
import Pageboy

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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.font(.Title3_M14)] //적용 안됨????
        
        navigationItem.title = "새싹 찾기"
        //1번째 탭
        scrollToPage(.at(index: 0), animated: false)
}
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func stopSearchBtnClicked() {
        
    }
    
//    private func stopStudy() {
//        viewModel.stopStudyVM { myQueue, statusCode in
//            <#code#>
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
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
