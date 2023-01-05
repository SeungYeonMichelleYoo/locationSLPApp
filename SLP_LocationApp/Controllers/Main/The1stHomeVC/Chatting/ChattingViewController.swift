//
//  ChattingViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//
import UIKit
import SocketIO
import Alamofire
import RealmSwift

class ChattingViewController: BaseViewController {
    
    let repository = ChatListRepository()
    var mainView = ChattingView()
    var viewModel = HomeViewModel()
    var chatViewModel = ChatViewModel()
    var chatList: [Chat] = []
    var matchedUid = ""
    var matchedNick = ""
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItems()
        configureTableView()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //SocketIOManager의 이벤트 수신에서 달은 NSnotificationcenter 받아오기
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
        
        mainView.menuView.reportStackView.addGestureRecognizer(getPressGesture())
        mainView.menuView.cancelStackView.addGestureRecognizer(getPressGesture2())
        mainView.menuView.reviewStackView.addGestureRecognizer(getPressGesture3())
        
        self.tabBarController?.tabBar.isHidden = true
        
        mainView.textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        //테이블뷰 새로고침시 realm 이전 채팅 불러오기
        mainView.mainTableView.refreshControl = UIRefreshControl()
        mainView.mainTableView.refreshControl?.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
    }
    
    @objc func refreshTableView(_ sender: Any) {
        //case 1) 배열 안에 뭐가 없는 경우: 오늘날짜 기준
        //case 2) 배열 안에 뭐가 있는 경우: 가져온 배열 중에서 가장 오래된날짜.(0번째 인덱스)
        mainView.mainTableView.refreshControl!.endRefreshing()
        chatList = repository.loadDBChats(myUid: UserDefaults.standard.string(forKey: "myUID")!, matchedUid: matchedUid, lastDate: chatList.count > 0 ? chatList[0].createdAt : Date().toString()) + chatList
        mainView.mainTableView.reloadData()
    }
    
    private func checkCurrentStatus() { //matchedNick, matchedUid 불러오기 위해서 씀
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIMyQueueStatusCode.success.rawValue:
                if myQueueState?.matched == 1 {
                    self.matchedNick = myQueueState?.matchedNick ?? ""
                    self.mainView.infoLabel.text = "\(self.matchedNick)님과 매칭되었습니다"
                    self.matchedUid = myQueueState?.matchedUid ?? ""
                    //Realm에 저장된 가장 마지막 날짜로부터 서버에서 최신 채팅 내용 불러오기
                    self.fetchChats(lastDate: self.repository.getLastChatDate(myUid: UserDefaults.standard.string(forKey: "myUID")!, matchedUid: myQueueState?.matchedUid ?? ""))
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
        self.repository.saveChat(data: ChatRealm(id: id, to: to, from: from, chat: chat, createdAt: createdAt))
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreBtnClicked() {
        mainView.plusbigView.isHidden.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCurrentStatus()
        self.navigationController?.navigationBar.isHidden = false
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
        
        if data.from == matchedUid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChatTableViewCell", for: indexPath) as! YourChatTableViewCell
            cell.chatLabel.text = data.chat
            cell.timeLabel.text = data.createdAt.toDate()?.getChatDateFormat()
            cell.backgroundColor = .white
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            cell.chatLabel.text = data.chat
            cell.timeLabel.text = data.createdAt.toDate()?.getChatDateFormat()
            cell.backgroundColor = .white
            return cell
        }
    }
}

extension ChattingViewController {
    //채팅 받아오기
    private func fetchChats(lastDate: String) {
        chatViewModel.fetchChatVM(from: matchedUid, lastchatDate: lastDate) { fetchingChatModel, statusCode in
            switch statusCode {
            case APIChatStatusCode.success.rawValue:
                self.chatList = fetchingChatModel!.payload
//                for chat in self.chatList {
//                    self.repository.saveChat(data: ChatRealm(id: chat.id, to: chat.to, from: chat.from, chat: chat.chat, createdAt: chat.createdAt))
//                }
                self.mainView.mainTableView.reloadData()
                if !self.chatList.isEmpty {
                    self.mainView.mainTableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .bottom, animated: false)
                }
                SocketIOManager.shared.establishConnection() //소켓 통신이 연결되는 시점 (스크롤 다 내린 시점에서) ->여기부터 실시간으로 데이터 받아오는 것 가능
                return
            case APIChatStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.fetchChats(lastDate: lastDate)
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
        chatViewModel.sendChatVM(chat: mainView.textView.text, to: matchedUid) { chat, statusCode in
            switch statusCode {
            case APIChatStatusCode.success.rawValue:
                self.chatList.append(chat!)
                self.mainView.mainTableView.reloadData()
                self.mainView.mainTableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .bottom, animated: false)
                self.repository.saveChat(data: ChatRealm(id: chat!.id, to: chat!.to, from: chat!.from, chat: chat!.chat, createdAt: chat!.createdAt))
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
