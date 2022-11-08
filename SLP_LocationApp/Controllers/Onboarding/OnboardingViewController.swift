//
//  OnboardingViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit

class OnboardingViewController: BaseViewController {
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0
    
    var mainView = OnboardingView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        
        slides = [
            OnboardingSlide(labelContent: "위치기반으로 빠르게 주위 친구를 확인", image: UIImage(named: "onboarding_img1")!),
            OnboardingSlide(labelContent: "스터디를 원하는 친구를 찾을 수 있어요", image: UIImage(named: "onboarding_img2")!),
            OnboardingSlide(labelContent: "SeSAC Study", image: UIImage(named: "onboarding_img3")!)
        ]
        
        mainView.startBtn.addTarget(self, action: #selector(startBtnClicked), for: .touchUpInside)
    }
    @objc func startBtnClicked() {
        let vc = AuthViewController()
        transition(vc, transitionStyle: .presentFullScreen)
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        mainView.pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
