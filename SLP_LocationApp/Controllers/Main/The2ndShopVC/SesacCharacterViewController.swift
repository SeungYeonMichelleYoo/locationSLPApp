//
//  SesacCharacterViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit

class SesacCharacterViewController: BaseViewController {
        
    var mainView = SesacCharacterView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
}
