//
//  ChattingViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import SocketIO

class ChattingViewController: BaseViewController {
    
    var mainView = ChattingView()
 
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        configureTableView()
        
        //on sesac으로 받은 이벤트를 처리하기 위한 Notification Observer (SocketIOManager의 이벤트 수신에서 달은 NSnotificationcenter 받아오기)
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
    }
    @objc func sendBtnClicked() {
        if mainView.textField.text!.count >= 1 {
            postChat(text: mainView.textField.text ?? "")
        }
    }
    
    @objc func getMessage(notification: NSNotification) {
        
    }
        
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreBtnClicked() {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SocketIOManager.shared.closeConnection()
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
        mainView.mainTableView.allowsSelection = false
        mainView.mainTableView.separatorStyle = .none
        mainView.mainTableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: let cell = tableView.dequeueReusableCell(withIdentifier: "YourChatTableViewCell", for: indexPath) as! YourChatTableViewCell
            return cell
            
        case 1: let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            
            return cell
        default: return UITableViewCell()
        }
    }
    
}


extension ChattingViewController {
    //채팅 가져오기
    private func fetchChats() {
    }
    
    //채팅 보내기
    private func postChat(text: String) {
    }
}
