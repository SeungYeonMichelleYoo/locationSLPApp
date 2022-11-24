//
//  SearchViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/22.
//

import UIKit

class SearchViewController: BaseViewController {
    
    var mainView = SearchView()
    var headerLabel = ["지금 주변에는","내가 하고 싶은"]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.black
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.titleView = searchBar
        
        configureCollectionView()
    }
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
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
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyCollectionViewCell", for: indexPath) as! StudyCollectionViewCell
            cell.nearBtn.setTitle("test", for: .normal)
            return cell
            
        case 1: let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStudyCollectionViewCell", for: indexPath) as! MyStudyCollectionViewCell
            cell.myBtn.setTitle("test", for: .normal)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyCollectionViewCell", for: indexPath) as! StudyCollectionViewCell
            cell.nearBtn.sizeToFit()
            let cellWidth = cell.nearBtn.frame.width + 20
            return CGSize(width: cellWidth, height: 40)
            
        case 1: let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStudyCollectionViewCell", for: indexPath) as! MyStudyCollectionViewCell
            cell.myBtn.sizeToFit()
            let cellWidth = cell.myBtn.frame.width + 20
            return CGSize(width: cellWidth, height: 40)
            
        default:
            return CGSize(width: 80, height: 40)
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
