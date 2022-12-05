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
    
    private var viewControllers = [NearViewController(), ReceivedRequestViewController()]
    private var titleList = ["새싹 찾기", "받은 요청"]
    
    var nearCount: Int = 0
    var opponentList: [OpponentModel] = []
    var receivedList: [OpponentModel] = []
    
    var mainView = FindTotalView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.dataSource = self
        
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
        if opponentList.count == 0 {
            (viewControllers[0] as! NearViewController).mainView.mainTableView.backgroundView = EmptyBigView()
        } else {
            (viewControllers[0] as! NearViewController).opponentList = opponentList
            (viewControllers[0] as! NearViewController).toggleBtns(hidden: true)
        }
        
        //2번째 탭 (받은요청)
        scrollToPage(.at(index: 1), animated: false)
        if receivedList.count == 0 {
            (viewControllers[1] as! ReceivedRequestViewController).mainView.mainTableView.backgroundView = EmptyReceivedBigView()
            // 이걸 EmptyBigView로 쓰고 mainLabel만 바꾸면 새파일을 만들필요가 없어지는데..... ??
        } else {
            (viewControllers[1] as! ReceivedRequestViewController).receivedList = receivedList
            (viewControllers[1] as! ReceivedRequestViewController).toggleBtns(hidden: true)
        }
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func stopSearchBtnClicked() {
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
