//
//  BirthViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//

import UIKit
import SnapKit

class BirthViewController: BaseViewController {
        
    var mainView = BirthView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
}
