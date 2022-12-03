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
