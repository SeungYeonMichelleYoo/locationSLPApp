//
//  NearPopUpViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/05.
//
import UIKit

final class NearPopUpViewController: BaseViewController {
    
    var mainView = NearPopUpView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.isOpaque = true
        
        mainView.cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        mainView.okBtn.addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
    }
    
    //popup뷰 이외에 클릭시 내려감 (탭제스쳐 효과)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != mainView.infoView {
            self.dismiss(animated: true)
        }
    }
    
    @objc func cancelBtnClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func okBtnClicked() {
        
    }
    
}

