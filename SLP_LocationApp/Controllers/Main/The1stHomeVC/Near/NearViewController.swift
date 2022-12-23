//
//  NearViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/22.
//
import UIKit

class NearViewController: BaseViewController {
    var viewModel = HomeViewModel()
    var mainView = NearView()
    var opponentList: [OpponentModel] = []
    var receivedList: [OpponentModel] = []
    var buttonTitle = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    var lat = 0.0
    var long = 0.0
    var requestedUid = ""
    var receivedUid = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        mainView.changeBtn.addTarget(self, action: #selector(changeBtnClicked), for: .touchUpInside)
    }
    @objc func changeBtnClicked() {
        changeStudy()
    }
    
    private func changeStudy() {
        viewModel.stopStudyVM { myQueue, statusCode in
            switch statusCode {
            case APIStopStudyStatusCode.success.rawValue:
                let vc = SearchViewController()
                self.transition(vc, transitionStyle: .push)
                return
            case APIStopStudyStatusCode.matched.rawValue:
                return
            case APIStopStudyStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.changeStudy()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIStopStudyStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func setupTableview() {
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
        mainView.mainTableView.register(NearPeopleTableViewCell.self, forCellReuseIdentifier: "NearPeopleTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        nearbySearch(lat: lat, long: long)
    }
    
    func toggleBtns(hidden: Bool) {
        mainView.btnsStackView.isHidden = hidden
    }
    
    //서버통신 갱신 위함
    private func nearbySearch(lat: Double, long: Double) {
        print("lat: \(lat), long: \(long)")
        self.viewModel.nearbySearchVM(lat: lat, long: long) { searchModel, statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                print("스터디 함께할 새싹 검색 성공")
                self.opponentList = searchModel!.fromQueueDB
                self.receivedList = searchModel!.fromQueueDBRequested
                self.mainView.mainTableView.reloadData()
                if self.opponentList.count == 0 {
                    self.mainView.mainTableView.backgroundView = EmptyBigView()
                } else {
                    self.toggleBtns(hidden: true)
                }
                return
            case APIStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.nearbySearch(lat: lat, long: long)
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
                
            case APIStatusCode.unAuthorized.rawValue:
                print("미가입회원")
                return
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                print("서버 점검중입니다. 관리자에게 문의해주세요.")
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
    
    func setCoordinate(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
        print("setCoordinate \(lat), \(long)")
        print("after: \(self.lat), \(self.long)")
    }
}

extension NearViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opponentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearPeopleTableViewCell", for: indexPath) as! NearPeopleTableViewCell
        cell.cellDelegate = self
        
        cell.requestBtn.tag = indexPath.row
    
        cell.nickLabel.text = opponentList[indexPath.row].nick
        cell.nickView.addGestureRecognizer(getPressGesture())
        cell.nickView.tag = indexPath.row
        cell.nickView.isUserInteractionEnabled = true
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = -1 - indexPath.row
        
        cell.studyCollectionView.delegate = self
        cell.studyCollectionView.dataSource = self
        cell.studyCollectionView.tag = indexPath.row
        cell.collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        cell.studyCollectionView.register(DemandStudyCollectionViewCell.self, forCellWithReuseIdentifier: "DemandStudyCollectionViewCell")
        print("index: \(indexPath.row) - \(opponentList[indexPath.row].nick) - \(opponentList[indexPath.row].studylist.count)")
        
        cell.studyCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        
        //하고싶은 스터디: 문제 생김
        if let flowLayout = cell.studyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                            print(UICollectionViewFlowLayout.automaticSize)
//                            print(flowLayout.estimatedItemSize)

//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        cell.studyCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !opponentList[indexPath.row].expanded {
            return 260
        } else {
            return 700
        }
    }
}

extension NearViewController: UIGestureRecognizerDelegate {
    
    fileprivate func getPressGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePress(gestureRecognizer:)))
        return tap
    }
    
    @objc func handlePress(gestureRecognizer: UITapGestureRecognizer) {
        let nickview: UIView = gestureRecognizer.view!
        opponentList[nickview.tag].expanded = !opponentList[nickview.tag].expanded
        mainView.mainTableView.reloadData()
    }
    
}

extension NearViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        if index < 0 {
            return buttonTitle.count
        } else {
            print("tag: \(index), count: \(opponentList[collectionView.tag].studylist.count)")
            return opponentList[collectionView.tag].studylist.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = collectionView.tag
        if index < 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as? TitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.titleBtn.setTitle("\(buttonTitle[indexPath.item])", for: .normal)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemandStudyCollectionViewCell", for: indexPath) as? DemandStudyCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.titleBtn.setTitle("\(opponentList[collectionView.tag].studylist[indexPath.item])", for: .normal)
            return cell
            
        }
    }
}
extension NearViewController: NearPeopleTableDelegate {
    func requestBtnTapped(sender: UIButton!) {
        let vc = NearPopUpViewController()
        print(sender.tag)
        vc.requestedUid = opponentList[sender.tag].uid
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
}
