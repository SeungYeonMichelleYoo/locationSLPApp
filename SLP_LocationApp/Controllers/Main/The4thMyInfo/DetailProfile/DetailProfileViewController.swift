//
//  DetailProfileViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/15.
//

import UIKit

//크게 2행으로 구성
//expandabletableviewcell, fixedtableviewcell
//expandabletableviewcell: 셀 클릭시 UIView 펼쳐지게 (UIView show, hide)

// var is_hidden = true
// ~~~ .isHidden = is_hidden
// is_hidden = !is_hidden

final class DetailProfileViewController: BaseViewController {
    var viewModel = UserViewModel()
    var mainView = DetailProfileView()
    var buttonTitle = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    var is_hidden = true
//    var is_on = false
    var gender = 0
    var ageMin = 18
    var ageMax = 65
    var searchable = 0
    var study = ""
    var nick = ""
    var background = 0
    var sesac = 0
    var reputation:[Int] = []
    var comment:[String] = []
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.black
        navigationItem.title = "정보 관리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        setupTableview()
        userCheckRecursion() //내정보 불러오는 통신
    }
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func saveBtnClicked() {
        var dict: Dictionary<String, String> = ["searchable": String(searchable), "ageMin": String(ageMin), "ageMax": String(ageMax), "gender": String(gender)]
        
        if (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).textField.text != "" {
            dict["study"] = (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).textField.text
        }
    
        viewModel.mypageUpdateVM(dict: dict) { statusCode in
            switch statusCode {
            case APIStatusCode.success.rawValue:
                self.showToast(message: "업데이트 성공")
            case APIStatusCode.unAuthorized.rawValue:
                self.showToast(message: "새싹 스터디 서버에 최종가입을 완료해주세요.")
            case APIStatusCode.serverError.rawValue: //서버 에러
                self.showToast(message: "서버 점검중입니다.")
            case APIStatusCode.clientError.rawValue:
                print("클라이언트 에러 - API요청시 header와 requestbody에 값을 빠뜨리지 않고 전송했는지 확인")
            case nil:
                self.showToast(message: "네트워크 연결을 확인해주세요.")
            default:
                break
            }
        }
    }
    func setupTableview() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func userCheckRecursion() {
        viewModel.userCheckVM { user, statusCode in
            print(statusCode)
            print(UserDefaults.standard.string(forKey: "idToken"))
            switch statusCode {
            case APIStatusCode.serverError.rawValue, APIStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            case APIStatusCode.firebaseTokenError.rawValue:
                self.viewModel.refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.userCheckRecursion()
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

            switch statusCode {
            case APIStatusCode.success.rawValue: //로그인 성공시
                self.background = user!.background
                self.nick = user!.nick
                print("여기 확인해야됨----nick: \(self.nick)") //들어오는거 성공
                self.background = user!.background
                self.sesac = user!.sesac
                self.reputation = user!.reputation
                self.comment = user!.comment
                self.gender = user!.gender
                self.study = user!.study
                self.searchable = user!.searchable
                self.ageMin = user!.ageMin
                self.ageMax = user!.ageMax
                self.mainView.tableView.reloadData()
                return
            case APIStatusCode.unAuthorized.rawValue, APIStatusCode.forbiddenNickname.rawValue:
                let vc = NicknameViewController()
                self.transition(vc, transitionStyle: .push)
                return
            case -1, nil:
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
                return
            default:
                break
            }
        }
    }
}

extension DetailProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.backimage.image = BackgroundImage.image(level: background)
            return cell
            
        case 1: let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableTableViewCell", for: indexPath) as! ExpandableTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
                        
            cell.nickLabel.text = "\(nick)"
            if comment.count == 0 {
                cell.moreBtn.isHidden = true
            } else {
                cell.moreBtn.isHidden = false
                cell.textView.text = "\(comment[0])"
            }
            
            cell.expandableView.isHidden = is_hidden
            cell.downBtn.setImage(UIImage(systemName: is_hidden ? "chevron.down" : "chevron.up"), for: .normal)
            
            cell.nickView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nickViewTapped)))
            cell.nickView.isUserInteractionEnabled = true
            
            return cell
            
        case 2: let cell = tableView.dequeueReusableCell(withIdentifier: "FixedTableViewCell", for: indexPath) as! FixedTableViewCell
            cell.cellDelegate = self
            gender == 0 ? cell.femaleBtn.fill() : cell.maleBtn.fill()
            if study.count != 0 {
                cell.textField.text = "\(study)"
            }
            cell.controlSwitch.isOn = searchable == 1
            cell.slider.minimumValue = CGFloat(ageMin)
            cell.slider.maximumValue = CGFloat(ageMax)
            return cell
        default: return UITableViewCell()
        }
    }
    
    @objc func nickViewTapped() {
        is_hidden = !is_hidden
        mainView.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200
        case 1:
            if (is_hidden) {
                return 60
            } else {
                return 400
            }
        case 2:
            return 400
        default: return 100
        }
    }
}

extension DetailProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleBtn.setTitle("\(buttonTitle[indexPath.item])", for: .normal)
        
        if reputation[indexPath.item] != 0 {
            cell.titleBtn.fill()
        }
            
        return cell
    }
}

//MARK: - FixedTableViewCell 안에 남,여 버튼 클릭시 기능 구현
extension DetailProfileViewController: FixedTableDelegate {
    func maleButtonTapped() {
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).femaleBtn.inactive()
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).maleBtn.fill()
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).maleBtn.layer.borderWidth = 0
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).maleBtn.setTitleColor(.white, for: .normal)
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).femaleBtn.setTitleColor(.black, for: .normal)
        gender = 1
    }
    
    func femaleButtonTapped() {
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).maleBtn.inactive()
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).femaleBtn.fill()
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).femaleBtn.layer.borderWidth = 0
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).femaleBtn.setTitleColor(.white, for: .normal)
        (mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).maleBtn.setTitleColor(.black, for: .normal)
        gender = 0
    }
    
    func withdrawBtnTapped() {
        let vc = WithdrawViewController()
        self.transition(vc, transitionStyle: .presentFullScreen)
    }
    
    func sliderTapped() {
        ageMin = Int((mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).slider.value[0])
        ageMax = Int((mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FixedTableViewCell).slider.value[1])
        print("min : \(ageMin),  max : \(ageMax)")
    }
    
    func switchTapped() {
        searchable = ((mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 2))) as! FixedTableViewCell).controlSwitch.isOn ? 1 : 0
    }
}

extension DetailProfileViewController {
    func withdraw() {
        viewModel.withdrawVM { statusCode in
            switch statusCode {
            case 200:
                UserDefaults.standard.removeObject(forKey: "idToken")
                self.showToast(message: "회원 탈퇴가 완료되었습니다.")
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
            case 401:
                self.showToast(message: "휴대폰 인증을 다시 해주세요.")
            case 406: //이미 탈퇴 처리된 회원, 미가입 회원
                self.showToast(message: "이미 탈퇴한 회원이거나 미가입 회원이십니다. 첫 화면으로 돌아갑니다.")
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
            case 500:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
            case 501:
                print("Client Error. API요청시 header, requestbody 값 빠뜨리지 않고 전송했는지 확인")
            case nil:
                self.showToast(message: "네트워크 연결을 확인해주세요.")
            default:
                break
            }
        }
    }
}
