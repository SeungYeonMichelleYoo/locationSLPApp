//
//  FriendViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FriendViewController: BaseViewController {
    
    var mainView = FriendView()
    var viewModel = HomeViewModel()
    var friendViewModel = FriendViewModel()
    var matchedUid = ""
    var matchedNick = ""
    
    var disposeBag = DisposeBag()
    
    var allObservable = Observable.of(Friend)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        configureTableView()
        checkCurrentStatus()
        attributeTableView()
        
        allObservable.bind(to: mainView.mainTableView.rx.items(cellIdentifier: FriendTableViewCell.registerId, cellType: FriendTableViewCell.self)) { [weak self] row, element, cell in
            cell.setData(element)
        }
        .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "friends_plus"), style: .plain, target: self, action: #selector(plusBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = Constants.BaseColor.black
    }
    @objc func plusBtnClicked() {
        
    }
    
    private func checkCurrentStatus() { //matchedNick, matchedUid 불러오기 위해서 씀
        viewModel.checkMatchStateVM { myQueueState, statusCode in
            switch statusCode {
            case APIMyQueueStatusCode.success.rawValue:
                if myQueueState?.matched == 1 {
                    self.matchedNick = myQueueState?.matchedNick ?? ""
                    self.mainView.mainTableView.reloadData()
                    self.matchedUid = myQueueState?.matchedUid ?? ""
                    //Realm에 저장된 가장 마지막 날짜로부터 서버에서 최신 채팅 내용 불러오기
                    //                    self.fetchChats(lastDate: self.repository.getLastChatDate(myUid: UserDefaults.standard.string(forKey: "myUID")!, matchedUid: myQueueState?.matchedUid ?? ""))
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
}

extension FriendViewController {
    private func attributeTableView() {
        view.backgroundColor = .white
        mainView.mainTableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.registerId)
    }
}


//extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
//    func configureTableView() {
//        mainView.mainTableView.delegate = self
//        mainView.mainTableView.dataSource = self
//        mainView.mainTableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendTableViewCell")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
//        cell.nameLabel.text = matchedNick
//        return cell
//    }
//
//    //스와이프해서 삭제하기
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//
//        }
//    }
//
//    //테이블 삭제 코멘트 Delete에서 삭제로 바꾸기
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "삭제"
//    }
//}
