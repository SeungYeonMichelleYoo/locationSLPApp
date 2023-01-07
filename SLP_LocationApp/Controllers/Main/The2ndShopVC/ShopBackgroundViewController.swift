//
//  ShopBackgroundViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit
import StoreKit

class ShopBackgroundViewController: BaseViewController {
        
    var mainView = ShopBackgroundView()
    var viewModel = ShopViewModel()
    var backgroundCollectionList: [Int] = []
    var backgroundPrice: [Int] = [0, 1200, 1200, 1200, 2500, 2500, 2500, 2500]
    var selectedBackground = -1
    
    let backgroundName = ["하늘공원", "씨티 뷰", "밤의 산책로", "낮의 산책로", "연극 무대", "라틴 거실", "홈트방", "뮤지션 작업실"]
    let backgroundDescription = [
        "새싹들을 많이 마주치는 매력적인 하늘 공원입니다", "창밖으로 보이는 도시 야경이 아름다운 공간입니다", "어둡지만 무섭지 않은 조용한 산책로입니다", "즐겁고 가볍게 걸을 수 있는 산책로입니다",
        "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다", "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다", "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다", "여러가지 음악 작업을 할 수 있는 작업실입니다"
    ]
    
    //1. 인앱 상품 ID 정의
    var productIdentifiers: Set<String> = ["com.memolease.sesac1.background1", "com.memolease.sesac1.background2", "com.memolease.sesac1.background3", "com.memolease.sesac1.background4", "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]
    
    //1. 인앱 상품 정보
    var productArray = Array<SKProduct>()
    var product: SKProduct? //구매할 상품
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        requestProductData()
    }
    
    func isSelectedInCollection() -> Bool {
        return backgroundCollectionList.contains(selectedBackground)
    }
    
    func setCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
}

extension ShopBackgroundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopBackgroundCollectionViewCell", for: indexPath) as? ShopBackgroundCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = backgroundName[indexPath.item]
        cell.contentLabel.text = backgroundDescription[indexPath.item]
        cell.backgroundImg.image = BackgroundImage.image(level: indexPath.item)
        cell.priceBtn.tag = indexPath.item
        if backgroundCollectionList.contains(indexPath.item) {
            cell.priceBtn.setTitle("보유", for: .normal)
            cell.priceBtn.setTitleColor(Constants.BaseColor.gray7, for: .normal)
            cell.priceBtn.cancel()
            cell.priceBtn.isUserInteractionEnabled = false
        } else {
            cell.priceBtn.setTitle(backgroundPrice[indexPath.item].numberFormat(), for: .normal)
            cell.priceBtn.setTitleColor(.white, for: .normal)
            cell.priceBtn.fill()
            cell.priceBtn.addTarget(self, action: #selector(priceBtnClicked), for: .touchUpInside)
        }
        return cell
    }
    @objc func priceBtnClicked(_ sender: UIButton) {
        let payment = SKPayment(product: productArray[sender.tag - 1])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell  = collectionView.cellForItem(at: indexPath) as! ShopBackgroundCollectionViewCell
        var vcList = self.navigationController!.viewControllers
        var count = 0
        for vc in vcList {
            if vc.isKind(of: ShopTabViewController.self) {
                (vc as! ShopTabViewController).mainView.backimage.image = BackgroundImage.image(level: indexPath.item)
                continue
            }
            count = count + 1
        }
        selectedBackground = indexPath.item
    }
}

//MARK: - InApp Purchase 관련
extension ShopBackgroundViewController: SKProductsRequestDelegate {
    //2. productIdentifiers에 정의된 상품 ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start() //인앱 상품 조회
        } else {
            print("In App Purchase Not Enabled")
        }
    }
    
    //3. 인앱 상품 정보 조회
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if products.count > 0 {
            for i in products {
                productArray.append(i)
                product = i //옵션. 테이블뷰 셀에서 구매하기 버튼 클릭 시
                print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
            }
        } else {
            print("No Product Found")
        }
    }
    
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        //구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        guard let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else {
            print("영수증확인 실패")
            return
        }
        print("영수증확인")
        print(receiptString) //구매시 영수증
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseRequest(receipt: receiptString, product: productIdentifier)
    }

    func purchaseRequest(receipt: String, product: String) {
        
        viewModel.purchaseRequestVM(receipt: receipt, product: product) { statusCode in
            switch statusCode {
            case APIPaymentStatusCode.success.rawValue:
                var vcList = self.navigationController!.viewControllers
                for i in 0 ..< vcList.count {
                    if vcList[i].isKind(of: ShopTabViewController.self) {
                        (vcList[i] as! ShopTabViewController).checkCurrentPurchaseStatus()
                        break
                    }
                }
                return
            case APIPaymentStatusCode.fail.rawValue:
                self.showToast(message: "결제에 실패하였습니다. 정상적인 방법으로 다시 구매해주세요.")
                return
            case APIPaymentStatusCode.firebaseTokenError.rawValue:
                UserViewModel().refreshIDToken { isSuccess in
                    if isSuccess! {
                        self.purchaseRequest(receipt: receipt, product: product)
                    } else {
                        self.showToast(message: "네트워크 연결을 확인해주세요. (Token 갱신 오류)")
                    }
                }
                return
            case APIPaymentStatusCode.serverError.rawValue, APIPaymentStatusCode.clientError.rawValue:
                self.showToast(message: "서버 점검중입니다. 관리자에게 문의해주세요.")
                return
            default: self.showToast(message: "네트워크 연결을 확인해주세요.")
                return
            }
        }
    }
}

extension ShopBackgroundViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("transaction count: \(transactions.count)")
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased: //구매 승인 이후에 영수증 검증
                print("Transaction Approved. \(transaction.payment.productIdentifier)") //이때까지 영수증 쫙 나옴
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
            case .failed: //실패 토스트, transaction
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print("Transaction default")
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransactions")
    }
}
