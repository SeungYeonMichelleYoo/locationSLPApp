//
//  ShopTabViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit
import Tabman
import Pageboy

class ShopTabViewController: TabmanViewController {
    
    private var viewControllers = [SesacCharacterViewController(), ShopBackgroundViewController()]
    private var titleList = ["새싹", "배경"]
    
    var mainView = ShopTabView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        configureBar()
        
    }
    
    func configureBar() {
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
        addBar(systemBar, dataSource: self, at: .custom(view: mainView.tabView, layout: nil))
    }
    
   
}
extension ShopTabViewController: PageboyViewControllerDataSource, TMBarDataSource {

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
