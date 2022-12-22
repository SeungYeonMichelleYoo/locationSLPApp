//
//  ChattingViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import SocketIO
import Alamofire

class ChattingViewController: BaseViewController {
    
    var mainView = ChattingView()
    
    var chat: [Chat] = []
 
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
            
        fetchChats()
        
        mainView.menuView.reportStackView.addGestureRecognizer(getPressGesture())
        mainView.menuView.cancelStackView.addGestureRecognizer(getPressGesture2())
        mainView.menuView.reviewStackView.addGestureRecognizer(getPressGesture3())
    }
    @objc func sendBtnClicked() {
        if mainView.textField.text!.count >= 1 {
            postChat(text: mainView.textField.text ?? "")
        }
    }
    
    @objc func getMessage(notification: NSNotification) {
        let id = notification.userInfo!["id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let userID = notification.userInfo!["userId"] as! String
        let value = Chat(id: id, chat: chat, createdAt: createdAt, from: userID, to: "")
        
        self.chat.append(value)
        mainView.mainTableView.reloadData()
        mainView.mainTableView.scrollToRow(at: IndexPath(row: self.chat.count - 1, section: 0), at: .bottom, animated: false)
    }
        
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreBtnClicked() {
        mainView.plusbigView.isHidden.toggle()
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
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = chat[indexPath.row]
        
        switch indexPath.row {
        case 0: let cell = tableView.dequeueReusableCell(withIdentifier: "YourChatTableViewCell", for: indexPath) as! YourChatTableViewCell
            cell.chatLabel.text = data.chat
            return cell
            
        case 1: let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            cell.chatLabel.text = data.chat
            return cell
        default: return UITableViewCell()
        }
    }
    
}


extension ChattingViewController {
    //채팅 가져오기
    private func fetchChats() {
            AF.request(UserAPI.BASEURL, method: .get).responseDecodable(of: [Chat].self) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.chat = value
                self?.mainView.mainTableView.reloadData()
                self?.mainView.mainTableView.scrollToRow(at: IndexPath(row: self!.chat.count - 1, section: 0), at: .bottom, animated: false)
                SocketIOManager.shared.establishConnection() //소켓 통신이 연결되는 시점 (스크롤 다 내린 시점에서) ->여기부터 실시간으로 데이터 받아오는 것 가능
            case .failure(let error):
                print("FAIL", error)
            }
        }
    }
    
    //채팅 보내기
    private func postChat(text: String) {
        AF.request("\(UserAPI.BASEURL)/v1/chat/{to}", method: .post, parameters: ["text": text], encoder: JSONParameterEncoder.default).responseString { data in
            print("POST CHAT SUCCEED", data)
        }
    }
}

extension ChattingViewController: UIGestureRecognizerDelegate {
    
    fileprivate func getPressGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(reportPress(gestureRecognizer:)))
        return tap
    }
    
    @objc func reportPress(gestureRecognizer: UITapGestureRecognizer) {
//        let nickview: UIView = gestureRecognizer.view!
       let vc = ChattingReportViewController()
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
    
    fileprivate func getPressGesture2() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelPress(gestureRecognizer:)))
        return tap
    }
    
    @objc func cancelPress(gestureRecognizer: UITapGestureRecognizer) {
        let vc = ChattingCancelViewController()
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
    
    fileprivate func getPressGesture3() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(reviewPress(gestureRecognizer:)))
        return tap
    }
    
    @objc func reviewPress(gestureRecognizer: UITapGestureRecognizer) {
        let vc = ChattingReviewViewController()
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
}
