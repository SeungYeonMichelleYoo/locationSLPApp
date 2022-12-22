//
//  ChattingCancelViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/21.
//
import UIKit

final class ChattingCancelViewController: BaseViewController {
    
    var mainView = ChattingCancelView()
    
    override func loadView() {
        self.view = mainView
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.isOpaque = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
    }
    @objc func cancelBtnClicked() {
        self.dismiss(animated: true)
    }
}
