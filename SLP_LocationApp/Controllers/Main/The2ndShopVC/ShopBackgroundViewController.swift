//
//  ShopBackgroundViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit

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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
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
        if backgroundCollectionList.contains(indexPath.item) {
            cell.priceBtn.setTitle("보유", for: .normal)
            cell.priceBtn.setTitleColor(Constants.BaseColor.gray7, for: .normal)
            cell.priceBtn.cancel()
            cell.priceBtn.isUserInteractionEnabled = false
        } else {
            cell.priceBtn.setTitle(backgroundPrice[indexPath.item].numberFormat(), for: .normal)
            cell.priceBtn.setTitleColor(.white, for: .normal)
            cell.priceBtn.fill()
        }
        return cell
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

