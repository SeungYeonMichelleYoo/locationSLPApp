//
//  SesacCharacterViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit

class SesacCharacterViewController: BaseViewController {
        
    var mainView = SesacCharacterView()
    
    var sesacName = ["기본 새싹", "튼튼 새싹", "민트 새싹", "퍼플 새싹", "골드 새싹"]
    var sesacDescription = ["새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.", "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다.", "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다.", "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다.", "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
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
        return cell
    }
}
