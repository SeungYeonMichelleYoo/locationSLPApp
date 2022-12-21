//
//  ChattingReportViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/21.
//
import UIKit

final class ChattingReportViewController: BaseViewController {
    
    var mainView = ChattingReportView()
    var buttonTitle = ["불법/사기", "불편한언행", "노쇼", "선정성", "인신공격", "기타"]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
