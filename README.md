# 🌱 현업 서비스 레벨 프로젝트 <새싹 스터디> 앱

<img width="1043" alt="스크린샷 2023-01-28 오전 9 38 27" src="https://user-images.githubusercontent.com/87454813/215230478-7e002591-da61-46b0-9bcc-55d386d9b8a2.png">


## 소개

내가 하고 싶은 '스터디'를 '주변 친구'를 찾아 함께 공부하고 싶을 때 사용하는 앱   
An App which can help to find out nearby study-friends based on current location    

지도에서 주변에 스터디를 원하는 사람을 검색 -> 함께 스터디를 하고 싶은 사람에게 '스터디 요청'을 전송 -> 상대방이 '스터디 수락'하면 채팅방이 열리고 채팅 시작    


## 화면 구성
<img width="551" alt="스크린샷 2023-01-30 오후 11 46 14" src="https://user-images.githubusercontent.com/87454813/215509707-471a8a1f-fed3-4d00-b8aa-bc67169e2261.png">


## 특징
- 서울 청년 취업사관학교 새싹 iOS 개발자 데뷔과정 중 진행한 마지막 프로젝트   
- 메모리스 회사에서 제공한 기획서(Confluence / Swagger), 디자인(Figma) 기반으로 제작   
- 의도된 서버 변경 및 장애 대응   


## 개발 기간 / 개발 환경
2022.11.08 - 2022.01.07 (8주)

<img width="95" src="https://img.shields.io/badge/Xcode-14.1.0-blue">
<img width="77" src="https://img.shields.io/badge/iOS-15.0+-silver">


## 사용한 기술 및 오픈소스 라이브러리   
<b>UI</b>   
Snapkit, UIKit, Autolayout, Toast, Tabman, IQKeyboardManager      
   
<b>지도</b>   
CLLocation, MapKit   
   
<b>디자인패턴</b>   
MVC 기반 MVVM 일부 구현   
   
<b>네트워크</b>   
Alamofire   
   
<b>DB</<b>   
Realm   
    
<b>기타</b>   
Firebase Auth, Firebase Messaging, async/await, Socket.IO, SPM, UserDefaults   


## 화면별 핵심 기능
|     화면    |    기능   |
| :--------: | :-------- |
|     공통      | FirebaseAuth 에 의해 휴대폰 번호 인증 후 화면 분기처리 (회원가입 또는 메인 지도 화면) |
|    회원가입    | 닉네임(8자 이하), 생년월일(UIPicker), 이메일(정규표현식), 성별 설정 |
|    메인 지도   |  MapKit, CLLocation / Custom Annotation 이용하여 주변 사용자 표시 |
|   스터디 찾기  | 글자 수에 따라 자유롭게 변경되는 사이즈의 Collection View Cell |
|    새싹샵     | StoreKit 인앱 결제 |
|   내 정보     | Custom CardView(테이블뷰 접혔다 펴지는 기능) |
|    채팅      | 실시간 1:1 대화 및 Realm DB 이용하여 과거 채팅 내용 불러오기  |


## 트러블 슈팅
✅ **서버단에서 어떠한 변수에 대한 값이 변경되더라도, 클라이언트단에서 업데이트 없이도 오류 없게끔 구현**

```swift
struct Chat: Codable {
    let id: String
    let to: String
    let from: String
    let chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to
        case from
        case chat
        case createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        to = try container.decode(String.self, forKey: .to)
        from = try container.decode(String.self, forKey: .from)
        chat = try container.decode(String.self, forKey: .chat)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
    
    init(id: String, to: String, from: String, chat: String, createdAt: String) {
        self.id = id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}

struct FetchingChatModel: Codable {
    let payload: [Chat]
}
```

✅ **리터럴한 값의 반복을 피하기 위한 함수 정의 - 새싹 얼굴 6개 / 배경 이미지 8개를 최대한 짧은 코드로 구현**

```swift
class BackgroundImage {
    static func image(level: Int) -> UIImage {
        return UIImage(named: "sesac_background_\(level + 1)")!
    }
}

class SesacFace {
    static func image(level: Int) -> UIImage {
        return UIImage(named: "sesac_face_\(level + 1)")!
    }
}
```   
   
✅ **1시간마다 firebase idToken이 만료되는 것에 대한 대응 / API StatusCode 에 따른 분기처리**

```swift
func userCheckRecursion() {
        viewModel.userCheckVM { user, statusCode in
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
                let vc = TabBarViewController()
                vc.setNick(nick: user!.nick)
                vc.setSesac(sesac: user!.sesac)
                UserDefaults.standard.set(user!.uid, forKey: "myUID")
                self.transition(vc, transitionStyle: .presentFullScreen)
                return
            case APIStatusCode.forbiddenNickname.rawValue:
                let vc = NicknameViewController()
                self.transition(vc, transitionStyle: .push)
                return
            case APIStatusCode.unAuthorized.rawValue:
                let vc = OnboardingViewController()
                self.transition(vc, transitionStyle: .presentFullScreen)
                return
            default:
                break
            }
        }
    }
```   
    
   
✅ **클릭시 접혔다 펴지는 CollectionViewCell에 대한 구현**   
![접었다폈다](https://user-images.githubusercontent.com/87454813/215513822-657cc96a-0ac0-4967-8cfe-4e7a82c98d56.gif)   
   
    
```swift
extension NearViewController: UIGestureRecognizerDelegate {
    
    fileprivate func getPressGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePress(gestureRecognizer:)))
        return tap
    }
    
    @objc func handlePress(gestureRecognizer: UITapGestureRecognizer) {
        let nickview: UIView = gestureRecognizer.view!
        opponentList[nickview.tag].expanded = !opponentList[nickview.tag].expanded
        mainView.mainTableView.reloadData()
        
        if !opponentList[nickview.tag].expanded {
            nearbySearch(lat: lat, long: long)
        }
    }
}
```  
    
  
✅ 테이블뷰 새로고침시 Realm 활용하여 과거 채팅 내역 불러오기  
    
![채팅RealmGIF](https://user-images.githubusercontent.com/87454813/215514086-63e3c3fb-b028-4e70-b4f2-e4d2eb98e667.gif)  

```swift
        mainView.mainTableView.refreshControl = UIRefreshControl()
        mainView.mainTableView.refreshControl?.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
    }
    
    @objc func refreshTableView(_ sender: Any) {
        //case 1) 배열 안에 뭐가 없는 경우: 오늘날짜 기준
        //case 2) 배열 안에 뭐가 있는 경우: 가져온 배열 중에서 가장 오래된날짜(0번째 인덱스)
        mainView.mainTableView.refreshControl!.endRefreshing()
        chatList = repository.loadDBChats(myUid: UserDefaults.standard.string(forKey: "myUID")!, matchedUid: matchedUid, lastDate: chatList.count > 0 ? chatList[0].createdAt : Date().toString()) + chatList
        mainView.mainTableView.reloadData()
```
  
  
## 회고
**🐣 성장한 부분** 

- **MVVM을 해당 프로젝트에서 처음으로 구현해보았다.**
    
    아직 조금 미흡한 부분이 있어서 MVC 패턴 기반으로 내가 할 수 있는 부분만 MVVM으로 구현해보았다. 
    
    확실히 반복되는 기능 및 서버 통신 부분에서 ViewController의 방대한 양의 코드를 줄일 수 있어서 좋았다. 다음 프로젝트 때에는 MVVM을 더 연습해서 확실하게 구현할 수 있도록 노력해야겠다.
    
- **현업 서비스 레벨의 프로젝트를 경험하며, 도중에 변경되는 서버에 대한 대응을 위한 코드를 짜는 연습함**

 **🙈 아쉬웠던 점** 

- **RxSwift 를 회원가입 과정에 녹여보았으면 좋았을 것 같다.**
    
    사용자가 회원가입하는 과정에 무언가를 입력하거나 선택하는 부분이 많았는데, 해당 부분은 반응형으로 구현해보았다면 조금 더 효율적인 코드가 되었을 것 같다.
    
- 원래 기획 및 디자인에 카카오톡 채팅 목록 화면을 가진 하나의 탭이 있었으나, 서버가 구현되어 있지 않아서 구현해보지 못했다.
- **폴더 구조 개선의 필요성을 느낌**
    
    하나의 Scene에 대해 ViewController / View / Model / ViewModel 로 더 쪼갰어야 했다.
