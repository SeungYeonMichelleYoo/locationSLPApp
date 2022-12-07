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
    let shopVC = ShopViewController()
    let friendVC = FriendViewController()
    let myinfoVC = MyInfoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        homeVC.title = "홈"
        shopVC.title = "새싹샵"
        friendVC.title = "새싹친구"
        myinfoVC.title = "내정보"
        
        homeVC.tabBarItem.image = UIImage(named: "home")
        shopVC.tabBarItem.image = UIImage(named: "shop")
        friendVC.tabBarItem.image = UIImage(named: "friend")
        myinfoVC.tabBarItem.image = UIImage(named: "myinfo")
          
        // navigationController의 root view 설정
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationShop = UINavigationController(rootViewController: shopVC)
        let navigationFriend = UINavigationController(rootViewController: friendVC)
        let navigationMyinfo = UINavigationController(rootViewController: myinfoVC)
        
        setViewControllers([navigationHome, navigationShop, navigationFriend, navigationMyinfo], animated: false)
        
        //TabBar 설정
        let tabBar: UITabBar = self.tabBar
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = Constants.BaseColor.gray6
        tabBar.tintColor = Constants.BaseColor.green
    }
    
    public func setNick(nick: String) {
        myinfoVC.nick = nick
        print(nick)
    }
    
    public func setSesac(sesac: Int) {
        myinfoVC.sesac = sesac
        print(sesac)
    }
}

