//
//  SesacCharacterViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit
import StoreKit

final class SesacCharacterViewController: BaseViewController {
    
    var mainView = SesacCharacterView()
    var viewModel = ShopViewModel()
    var sesacCollectionList: [Int] = []
    var sesacPrice: [Int] = [0, 1200, 2500, 2500, 2500]
    var selectedSesac = -1
    
    var sesacName = ["기본 새싹", "튼튼 새싹", "민트 새싹", "퍼플 새싹", "골드 새싹"]
    var sesacDescription = ["새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.", "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다.", "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다.", "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다.", "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."]
    
    //1. 인앱 상품 ID 정의
    var productIdentifiers: Set<String> = ["com.memolease.sesac1.sprout1", "com.memolease.sesac1.sprout2", "com.memolease.sesac1.sprout3", "com.memolease.sesac1.sprout4"]
    
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
        return sesacCollectionList.contains(selectedSesac)
    }
    
    func setCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
}
extension SesacCharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesacName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SesacFaceCollectionViewCell", for: indexPath) as? SesacFaceCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = sesacName[indexPath.item]
        cell.contentLabel.text = sesacDescription[indexPath.item]
        cell.sesacImg.image = SesacFace.image(level: indexPath.item)
        DispatchQueue.main.async(execute:{
            cell.sesacImg.makeRoundedRadius()
        })
        cell.priceBtn.tag = indexPath.item
        
        if sesacCollectionList.contains(indexPath.item) {
            cell.priceBtn.setTitle("보유", for: .normal)
            cell.priceBtn.setTitleColor(Constants.BaseColor.gray7, for: .normal)
            cell.priceBtn.cancel()
            cell.priceBtn.isUserInteractionEnabled = false
        } else {
            cell.priceBtn.setTitle(sesacPrice[indexPath.item].numberFormat(), for: .normal)
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
        let cell = collectionView.cellForItem(at: indexPath) as! SesacFaceCollectionViewCell
        
        var vcList = self.navigationController!.viewControllers
        var count = 0
        for vc in vcList {
            if vc.isKind(of: ShopTabViewController.self) {
                (vc as! ShopTabViewController).mainView.sesacImg.image = SesacFace.image(level: indexPath.item)
                continue
            }
            count = count + 1
        }
        selectedSesac = indexPath.item
    }
}

//MARK: - InApp Purchase 관련
extension SesacCharacterViewController: SKProductsRequestDelegate {
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

extension SesacCharacterViewController: SKPaymentTransactionObserver {
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
