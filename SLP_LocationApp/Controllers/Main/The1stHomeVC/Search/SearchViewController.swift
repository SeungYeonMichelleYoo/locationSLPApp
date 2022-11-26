//
//  SearchViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/22.
//

import UIKit

final class SearchViewController: BaseViewController, UITextFieldDelegate {
    
    var mainView = SearchView()
    var headerLabel = ["지금 주변에는","내가 하고 싶은"]
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
        
        txtfield.addTarget(self, action: #selector(txtfieldEditingChanged), for: .editingChanged)
    }
    @objc func txtfieldEditingChanged() {
        myStudy = txtfield.text?.components(separatedBy: " ").filter({
            $0.count > 0
        }) ?? []
        
        if myStudy.count >= 8 {
            showToast(message: "스터디를 더 이상 추가할 수 없습니다.")
        }
        
        for new in myStudy {
            if new.count == 0 || new.count > 8 {
                showToast(message: "최소 한 자 이상, 최대 8글자까지 작성 가능합니다")
            }
        }
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

extension SearchViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtfield.text?.count == 0 || (txtfield.text!.count) > 8 {
            showToast(message: "최소 한 자 이상, 최대 8글자까지 작성 가능합니다")
        } else {
            
            myStudy.append(contentsOf: newStudy.filter({
                !myStudy.contains($0)
            }))
            
            txtfield.resignFirstResponder()
            
            mainView.collectionView.reloadData()
        }
        return true
    }
}
