//
//  SearchViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/22.
//

import UIKit

final class SearchViewController: BaseViewController, UITextFieldDelegate {
    
    var viewModel = HomeViewModel()
    var lat: Double = 37.517819364682694
    var long: Double = 126.88647317074734
    var mainView = SearchView()
    var headerLabel = ["지금 주변에는","내가 하고 싶은"]
    var recommendStudy: [String] = []
    var nearStudy: [String] = []
    var myStudy: [String] = []
    var newStudy: [String] = []
    let txtfield = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 35))
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.black
        
        configureTextField()
        configureCollectionView()
        getstudyList()
        
        mainView.searchBtn.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        print("lat: \(lat)")
        print(long)
        
        self.tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            mainView.searchBtn.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardSize.height)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(48)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        mainView.searchBtn.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    @objc func searchBtnClicked() {
        getNearPeople()
    }
    
    func getNearPeople() {
        viewModel.nearbySearchVM(lat: lat, long: long) { searchModel, statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                let vc = FindTotalViewController()
                vc.opponentList = searchModel!.fromQueueDB
                vc.receivedList = searchModel!.fromQueueDBRequested
                print("searchview - opponentList count: \(searchModel!.fromQueueDB.count)")
                print("searchview - receivedList count: \(searchModel!.fromQueueDBRequested.count)")
                vc.tabBarController?.tabBar.isHidden = true
                vc.hidesBottomBarWhenPushed = true // 안 먹힘 왜???
                self.transition(vc, transitionStyle: .push)
                return
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            case APIStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.getNearPeople()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case nil:
                self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            default:
                break
            }
        }
    }
    
    func getstudyList() {
        viewModel.nearbySearchVM(lat: lat, long: long) { searchModel, statusCode in
            print(statusCode)
            switch statusCode {
            case APIStatusCode.success.rawValue:
                for opponent in searchModel!.fromQueueDB {
                    print(opponent.studylist)
                    self.nearStudy = self.nearStudy + opponent.studylist
                }
                for recomStudy in searchModel!.fromRecommend {
                    self.recommendStudy.append(recomStudy)
                }
                self.nearStudy = ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8"]
                self.nearStudy = self.nearStudy.uniqued()
                print(self.nearStudy)
                self.mainView.nearCollectionView.reloadData()
                return
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            case APIStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.getstudyList()
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case nil:
                self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            default:
                break
            }
        }
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureTextField() {
        txtfield.layer.cornerRadius = 8
        txtfield.attributedPlaceholder = NSAttributedString(string: "띄어쓰기로 복수 입력이 가능해요", attributes: [.foregroundColor: Constants.BaseColor.gray6])
        txtfield.backgroundColor = Constants.BaseColor.gray1
        txtfield.font = UIFont.font(.Title4_R14)
        txtfield.leftViewMode = UITextField.ViewMode.always
        let txtfieldLeftView = UIView(frame: CGRect(x: 5, y: 0, width: 35, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        let image = UIImage(named: "magnifyingglass")
        imageView.image = image
        imageView.image = image
        txtfieldLeftView.addSubview(imageView)
        txtfield.leftView = txtfieldLeftView
        txtfield.returnKeyType = UIReturnKeyType.done
        
        self.navigationItem.titleView = txtfield
        
        txtfield.delegate = self
    }
    
    func configureCollectionView() {
        mainView.nearCollectionView.delegate = self
        mainView.myCollectionView.delegate = self
        mainView.nearCollectionView.dataSource = self
        mainView.myCollectionView.dataSource = self
        
        mainView.nearCollectionView.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: "StudyCollectionViewCell")
        mainView.myCollectionView.register(MyStudyCollectionViewCell.self, forCellWithReuseIdentifier: "MyStudyCollectionViewCell")
        
        
        mainView.nearCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        mainView.myCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = mainView.nearCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        if let flowLayout = mainView.myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.nearCollectionView {
            return recommendStudy.count + nearStudy.count
        } else {
            print("mine === \(section): \(myStudy.count)")
            return myStudy.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainView.nearCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyCollectionViewCell", for: indexPath) as! StudyCollectionViewCell
            
            if indexPath.item < recommendStudy.count {
                cell.nearBtn.setTitle(recommendStudy[indexPath.item], for: .normal)
                cell.nearBtn.sizeToFit()
                cell.nearBtn.layer.borderWidth = 1.0
                cell.nearBtn.layer.cornerRadius = 8
                cell.nearBtn.layer.borderColor = Constants.BaseColor.error.cgColor
                cell.nearBtn.configuration?.baseForegroundColor = Constants.BaseColor.error
                
            } else {
                cell.nearBtn.setTitle(nearStudy[indexPath.item - recommendStudy.count], for: .normal)
                cell.nearBtn.sizeToFit()
                cell.nearBtn.layer.borderWidth = 0.0
                cell.nearBtn.layer.cornerRadius = 8
                cell.nearBtn.layer.borderColor = Constants.BaseColor.gray4.cgColor
                cell.nearBtn.configuration?.baseForegroundColor = Constants.BaseColor.black
                //            cell.myBtn.frame.size = CGSize(width: cell.myBtn.intrinsicContentSize.width, height: cell.myBtn.intrinsicContentSize.height)
                //            cell.frame.size = CGSize(width: cell.myBtn.intrinsicContentSize.width + 20, height: cell.myBtn.intrinsicContentSize.height)
                // button label mother father cousin uncle
                // n 번째 버튼의 x: 직전 값의 x + 직전 값의 너비 + 여백
                //              현재 x + 현재 너비가 기기 사이즈보다 클 경우, 0으로 수정 후, y값을 직전 버튼의 y값 + 높이 + 줄간 여백
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStudyCollectionViewCell", for: indexPath) as! MyStudyCollectionViewCell
            cell.myBtn.setTitle(myStudy[indexPath.item], for: .normal)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainView.nearCollectionView {
            return CGSize(width: (indexPath.item < recommendStudy.count ? recommendStudy[indexPath.item] : nearStudy[indexPath.item - recommendStudy.count]).size(withAttributes: [NSAttributedString.Key.font : UIFont.font(.Title4_R14)]).width + 32 + 14, height: 32)
        } else {
            return CGSize(width: myStudy[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.font(.Title4_R14)]).width + 32 + 22, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.nearCollectionView {
            if myStudy.count < 8 {
                if indexPath.item < recommendStudy.count {
                    myStudy.append(recommendStudy[indexPath.item])
                    recommendStudy.remove(at: indexPath.item)
                } else {
                    myStudy.append(nearStudy[indexPath.item - recommendStudy.count])
                    nearStudy.remove(at: indexPath.item - recommendStudy.count)
                }
                
                mainView.myCollectionView.reloadData()
                mainView.nearCollectionView.reloadData()
            } else {
                showToast(message: "스터디를 더 이상 추가할 수 없습니다.")
            }
        } else {
            print("myStudy count: \(myStudy.count), index: \(indexPath.item)")
            myStudy.remove(at: indexPath.item)
            mainView.myCollectionView.reloadData()
        }
    }
}


extension SearchViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var words = txtfield.text?.components(separatedBy: " ").filter({
            $0.count > 0
        }) ?? []
        
        if myStudy.count + words.count >= 8 {
            showToast(message: "스터디를 더 이상 추가할 수 없습니다.")
        }
        
        for word in words {
            if word.count == 0 || (word.count) > 8 {
                showToast(message: "최소 한 자 이상, 최대 8글자까지 작성 가능합니다")
                continue
            } else {
                if !myStudy.contains(word) {
                    myStudy.append(word)
                }
                words.removeAll { $0 == word }
            }
        }
        txtfield.text = words.joined(separator: " ")
        
        txtfield.resignFirstResponder()
        
        mainView.myCollectionView.reloadData()
        return true
    }
}
