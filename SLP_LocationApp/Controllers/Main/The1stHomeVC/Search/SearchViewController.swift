//
//  SearchViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/22.
//

import UIKit

final class SearchViewController: BaseViewController, UITextFieldDelegate {
    
    var viewModel = HomeViewModel()
    var lat: Double = 0.0
    var long: Double = 0.0
    var mainView = SearchView()
    var headerLabel = ["지금 주변에는","내가 하고 싶은"]
    var recommendStudy: [String] = []
    var nearStudy: [String] = []
    var myStudy: [String] = []
//    var myStudyBtns = self.mainView.collectionView.MyStudyCollectionViewCell.myBtn
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
    }
    
    func getstudyList() {
        viewModel.nearbySearchVM(lat: lat, long: long) { searchModel, statusCode in
            print(statusCode)
            switch statusCode {
            case APIStatusCode.success.rawValue:
                self.nearStudy = []
                for opponent in searchModel!.fromQueueDB {
//                    var opponentStudyList = opponent.studylist.split(separator: ", ")
//                    opponentStudyList = opponentStudyList
//                    for study in opponentStudyList {
//                        print(study)
//                        self.nearStudy.append(study)
//                    }
                }
                for opponent in searchModel!.fromQueueDBRequested {
                    print(opponent.studylist)
                    self.nearStudy = self.nearStudy + opponent.studylist
                }
                for recomStudy in searchModel!.fromRecommend {
                    self.nearStudy.append(recomStudy)
                }
                self.nearStudy = self.nearStudy.uniqued()
                print(self.nearStudy)
                self.mainView.collectionView.reloadData()
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
        txtfieldLeftView.addSubview(imageView)
        txtfield.leftView = txtfieldLeftView
        txtfield.returnKeyType = UIReturnKeyType.done
        
        self.navigationItem.titleView = txtfield
        
        txtfield.delegate = self
    }
    
    func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        mainView.collectionView.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: "StudyCollectionViewCell")
        mainView.collectionView.register(MyStudyCollectionViewCell.self, forCellWithReuseIdentifier: "MyStudyCollectionViewCell")
        mainView.collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderReusableView")
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return nearStudy.count + recommendStudy.count
        } else {
            return myStudy.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyCollectionViewCell", for: indexPath) as! StudyCollectionViewCell
            cell.nearBtn.setTitle(nearStudy[indexPath.item], for: .normal)
            cell.nearBtn.sizeToFit()
            cell.nearBtn.frame.size = CGSize(width: cell.nearBtn.intrinsicContentSize.width, height: cell.nearBtn.intrinsicContentSize.height)
            cell.frame.size = CGSize(width: cell.nearBtn.intrinsicContentSize.width + 20, height: cell.nearBtn.intrinsicContentSize.height)
            return cell
            
        case 1: let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStudyCollectionViewCell", for: indexPath) as! MyStudyCollectionViewCell
            cell.myBtn.setTitle(myStudy[indexPath.item], for: .normal)
            cell.myBtn.sizeToFit()
            cell.myBtn.frame.size = CGSize(width: cell.myBtn.intrinsicContentSize.width, height: cell.myBtn.intrinsicContentSize.height)
            cell.frame.size = CGSize(width: cell.myBtn.intrinsicContentSize.width + 20, height: cell.myBtn.intrinsicContentSize.height)
            return cell
            // button label mother father cousin uncle
            // n 번째 버튼의 x: 직전 값의 x + 직전 값의 너비 + 여백
            //              현재 x + 현재 너비가 기기 사이즈보다 클 경우, 0으로 수정 후, y값을 직전 버튼의 y값 + 높이 + 줄간 여백
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderReusableView", for: indexPath) as? HeaderReusableView {
            sectionHeader.headerLabel.text = headerLabel[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
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
        
        mainView.collectionView.reloadData()
        return true
    }
}
