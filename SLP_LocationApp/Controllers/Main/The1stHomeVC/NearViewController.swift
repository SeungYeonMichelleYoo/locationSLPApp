//
//  NearViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/22.
//
import UIKit

class NearViewController: BaseViewController {
    
    var mainView = NearView()
 
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
}
