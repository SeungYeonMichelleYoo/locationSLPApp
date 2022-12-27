//
//  OnboardingViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import FirebaseAuth

final class OnboardingViewController: BaseViewController {
    
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
        print("height: \(UIScreen.main.bounds.height)")
        slides = [
            OnboardingSlide(labelContent: "위치 기반으로 빠르게\n 주위 친구를 확인", image: UIImage(named: "onboarding_img1")!),
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

        var text = cell.contentLabel.text
        let attributeString = NSMutableAttributedString(string: text!)
        attributeString.addAttribute(.foregroundColor, value: Constants.BaseColor.green, range: (text! as NSString).range(of: "위치 기반"))
        attributeString.addAttribute(.foregroundColor, value: Constants.BaseColor.green, range: (text! as NSString).range(of: "스터디를 원하는 친구"))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        paragraphStyle.lineSpacing = 10
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
        cell.contentLabel.attributedText = attributeString
        return cell
    }
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(max(0, round(scrollView.contentOffset.x / UIScreen.main.bounds.width)))
        mainView.pageControl.currentPage = currentPage
        mainView.collectionView.reloadData()
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
