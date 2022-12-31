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
    var viewModel = HomeViewModel()
    var chatViewModel = ChatViewModel()
    var chatList: [Chat] = []
    var matchedUid = ""
    var matchedNick = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItems()
        configureTableView()
        
        //on sesac으로 받은 이벤트를 처리하기 위한 Notification Observer (SocketIOManager의 이벤트 수신에서 달은 NSnotificationcenter 받아오기)
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
        
        mainView.menuView.reportStackView.addGestureRecognizer(getPressGesture())
        mainView.menuView.cancelStackView.addGestureRecognizer(getPressGesture2())
        mainView.menuView.reviewStackView.addGestureRecognizer(getPressGesture3())
        
        self.tabBarController?.tabBar.isHidden = true
        
        mainView.textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    private func checkCurrentStatus() { //matchedNick 불러오기 위해서 씀
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIMyQueueStatusCode.success.rawValue:
                if myQueueState?.matched == 1 {
                    self.matchedNick = myQueueState?.matchedNick ?? ""
                    self.mainView.infoLabel.text = "\(self.matchedNick)님과 매칭되었습니다"
                    self.matchedUid = myQueueState?.matchedUid ?? ""
                    self.fetchChats()
                }
                return
            case APIMyQueueStatusCode.noSearch.rawValue:
                return
            case APIMyQueueStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.checkCurrentStatus()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIMyQueueStatusCode.serverError.rawValue, APIMyQueueStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func configureNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            mainView.textView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardSize.height)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(48)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        mainView.textView.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    @objc func sendBtnClicked() {
        if mainView.textView.text!.count >= 1 {
            sendChat()
            mainView.textView.text = ""
            mainView.sendBtn.setImage(UIImage(named: "chat_send_gray"), for: .normal)
        }
    }
    
    @objc func getMessage(notification: NSNotification) {
        let id = notification.userInfo!["_id"] as! String
        let to = notification.userInfo!["to"] as! String
        let from = notification.userInfo!["from"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        
        let value = Chat(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
        
        self.chatList.append(value)
        mainView.mainTableView.reloadData()
        mainView.mainTableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreBtnClicked() {
        mainView.plusbigView.isHidden.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCurrentStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var vcList = self.navigationController!.viewControllers
        for i in 0 ..< vcList.count {//NoNetwork, TabBar, Search, FindTotal
            if vcList[i].isKind(of: SearchViewController.self) {
                vcList.remove(at: i)
                break
            }
        }
        self.navigationController!.viewControllers = vcList
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SocketIOManager.shared.closeConnection()
    }
    
    //textview 외의 화면 클릭시 키보드 내리기 + textview placeholder 설정
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        mainView.textView.text = "메시지를 입력하세요"
        mainView.textView.textColor = Constants.BaseColor.gray7
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
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = chatList[indexPath.row]
        
        switch indexPath.row {
        case 0: let cell = tableView.dequeueReusableCell(withIdentifier: "YourChatTableViewCell", for: indexPath) as! YourChatTableViewCell
            cell.chatLabel.text = data.chat
            cell.timeLabel.text = data.createdAt
            //getChatDateFormat(memodate: data.createdAt.toDate())
            cell.backgroundColor = .white
            return cell
            
        case 1: let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            cell.chatLabel.text = data.chat
            cell.timeLabel.text = data.createdAt
            cell.backgroundColor = .white
            return cell
        default: return UITableViewCell()
        }
    }
}

extension ChattingViewController {
    //채팅 받아오기
    private func fetchChats() {
        print(matchedUid)
        chatViewModel.fetchChatVM(from: matchedUid, lastchatDate: "2000-01-01") { fetchingChatModel, statusCode in
            switch statusCode {
            case APIChatStatusCode.success.rawValue:
                self.chatList = fetchingChatModel!.payload
                print(self.chatList)
                self.mainView.mainTableView.reloadData()
                if !self.chatList.isEmpty {
                    self.mainView.mainTableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .bottom, animated: false)
                }
                SocketIOManager.shared.establishConnection() //소켓 통신이 연결되는 시점 (스크롤 다 내린 시점에서) ->여기부터 실시간으로 데이터 받아오는 것 가능
                return
            case APIChatStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.sendChat()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIChatStatusCode.serverError.rawValue, APIChatStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    //채팅 보내기
    private func sendChat() {
        print("sendChat 되는지 확인 여기여기")
        chatViewModel.sendChatVM(chat: mainView.textView.text, to: matchedUid) { chat, statusCode in
            switch statusCode {
            case APIChatStatusCode.success.rawValue:
                return
            case APIChatStatusCode.fail.rawValue: //일반상태
                return
            case APIChatStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.sendChat()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIChatStatusCode.serverError.rawValue, APIChatStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
}

extension ChattingViewController: UIGestureRecognizerDelegate {
    
    fileprivate func getPressGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(reportPress(gestureRecognizer:)))
        return tap
    }
    
    @objc func reportPress(gestureRecognizer: UITapGestureRecognizer) {
        mainView.plusbigView.isHidden = true
        let vc = ChattingReportViewController()
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
    
    fileprivate func getPressGesture2() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelPress(gestureRecognizer:)))
        return tap
    }
    
    @objc func cancelPress(gestureRecognizer: UITapGestureRecognizer) {
        mainView.plusbigView.isHidden = true
        let vc = ChattingCancelViewController()
        vc.otheruid = matchedUid
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
    
    fileprivate func getPressGesture3() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(reviewPress(gestureRecognizer:)))
        return tap
    }
    
    @objc func reviewPress(gestureRecognizer: UITapGestureRecognizer) {
        mainView.plusbigView.isHidden = true
        let vc = ChattingReviewViewController()
        vc.matchedNick = matchedNick
        vc.otheruid = matchedUid
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
}

extension ChattingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메시지를 입력하세요"
            textView.textColor = Constants.BaseColor.gray7
            textView.resignFirstResponder()
            mainView.sendBtn.setImage(UIImage(named: "chat_send_gray"), for: .normal)
        } else {
            textView.textColor = .black
            mainView.sendBtn.setImage(UIImage(named: "chat_send_green"), for: .normal)
        }
    }
    
}
