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
    var viewModel = ShopViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        configureBar()
        
        mainView.saveBtn.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        
        checkCurrentPurchaseStatus()
    }
    
    @objc func saveBtnClicked() {
        if (viewControllers[0] as!SesacCharacterViewController).isSelectedInCollection() && (viewControllers[1] as! ShopBackgroundViewController).isSelectedInCollection() {
            showToast(message: "성공적으로 저장되었습니다")
            DispatchQueue.main.async {
                self.updateWhenSave()
            }
        } else {
            showToast(message: "구매가 필요한 아이템이 있어요")
        }
    }
    
    func checkCurrentPurchaseStatus() {
        viewModel.checkPurchaseStateVM { user, statusCode in
            switch statusCode {
            case APIShopCurrentStatusCode.success.rawValue:
                (self.viewControllers[0] as! SesacCharacterViewController).sesacCollectionList = user!.sesacCollection
                (self.viewControllers[1] as! ShopBackgroundViewController).backgroundCollectionList = user!.backgroundCollection
                
                (self.viewControllers[0] as! SesacCharacterViewController).selectedSesac = user!.sesac
                (self.viewControllers[1] as! ShopBackgroundViewController).selectedBackground = user!.background
                
                self.mainView.sesacImg.image = SesacFace.image(level: user!.sesac)
                self.mainView.backimage.image = BackgroundImage.image(level: user!.background)
                
                (self.viewControllers[0] as! SesacCharacterViewController).mainView.collectionView.reloadData()
                (self.viewControllers[1] as! ShopBackgroundViewController).mainView.collectionView.reloadData()
                return
            case APIShopCurrentStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.checkCurrentPurchaseStatus()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIShopCurrentStatusCode.serverError.rawValue, APIShopCurrentStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func updateWhenSave() {
        viewModel.updateWhenSaveVM(sesac: (viewControllers[0] as! SesacCharacterViewController).selectedSesac, background: (viewControllers[1] as! ShopBackgroundViewController).selectedBackground) { statusCode in
            switch statusCode {
            case APIShopUpdateStatusCode.success.rawValue:
                return
            case APIShopUpdateStatusCode.NeedPurchase.rawValue: //토스트 메시지 띄우기
                return
            case APIShopUpdateStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.updateWhenSave()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIShopUpdateStatusCode.serverError.rawValue, APIShopUpdateStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
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
