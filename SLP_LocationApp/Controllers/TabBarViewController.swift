//
//  TabBarViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit

final class TabBarViewController: UITabBarController {
    
    let homeVC = MainMapViewController()
    let shopVC = ShopTabViewController()
    let friendVC = FriendViewController()
    let myinfoVC = MyInfoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let vc = self.presentingViewController else { return }

//        while (vc.presentingViewController != nil) {
//            print("before vc ---- ")
//            print(vc)
//            if vc.isKind(of: NoNetworkViewController.self) || vc.isKind(of: TabBarViewController.self
//            ) {
//                continue
//            }
//            vc.dismiss(animated: true, completion: nil)
//        }
//        guard let vc2 = self.presentingViewController else { return }
//        while (vc2.presentingViewController != nil) {
//            print("after vc ---- ")
//            print(vc2)
//        }
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate

//        if appDelegate.window?.rootViewController?.presentedViewController != nil {
//            var counter = 0
//            for vc in vcList {//NoNetwork, TabBar, Search, FindTotal
//                print(vc)
//                if vc.isKind(of: OnboardingViewController.self) || vc.isKind(of: AuthViewController.self) || vc.isKind(of: SMSCodeViewController.self) || vc.isKind(of: BirthViewController.self) || vc.isKind(of: NicknameViewController.self) || vc.isKind(of: EmailViewController.self) || vc.isKind(of: GenderViewController.self) {
//                    vcList.remove(at: counter)
//                    continue
//                }
//                counter = counter + 1
//            }
//            self.navigationController!.viewControllers = vcList
//        }
                
        homeVC.title = "홈"
        shopVC.title = "새싹샵"
        friendVC.title = "새싹친구"
        myinfoVC.title = "내정보"
        
        homeVC.tabBarItem.image = UIImage(named: "home")
        shopVC.tabBarItem.image = UIImage(named: "shop")
        friendVC.tabBarItem.image = UIImage(named: "friend")
        myinfoVC.tabBarItem.image = UIImage(named: "myinfo")
        
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationShop = UINavigationController(rootViewController: shopVC)
        let navigationFriend = UINavigationController(rootViewController: friendVC)
        let navigationMyinfo = UINavigationController(rootViewController: myinfoVC)
        
        setViewControllers([navigationHome, navigationShop, navigationFriend, navigationMyinfo], animated: false)
        
        //TabBar 설정
        let tabBar: UITabBar = self.tabBar
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = Constants.BaseColor.gray6
        tabBar.tintColor = Constants.BaseColor.green
    }
    
    public func setNick(nick: String) {
        myinfoVC.nick = nick
    }
    
    public func setSesac(sesac: Int) {
        myinfoVC.sesac = sesac
    }
}

