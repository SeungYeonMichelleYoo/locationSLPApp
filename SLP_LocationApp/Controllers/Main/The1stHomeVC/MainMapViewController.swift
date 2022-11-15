//
//  MainMapViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//

import UIKit
import SnapKit

class MainMapViewController: BaseViewController {
        
    var mainView = MainMapView()
    
    var gender = 0
    
    var emailAddress = ""
    
    var phoneNumber = ""
    
    var FCMtoken = ""

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
}
