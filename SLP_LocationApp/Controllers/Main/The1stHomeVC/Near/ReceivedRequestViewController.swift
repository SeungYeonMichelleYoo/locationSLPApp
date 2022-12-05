//
//  ReceivedRequestViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/26.
//

import UIKit

class ReceivedRequestViewController: BaseViewController {
    
    var mainView = ReceivedRequestView()
    var receivedList: [OpponentModel] = []
    var buttonTitle = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
 
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
    }
    
    func setupTableview() {
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
        mainView.mainTableView.register(NearPeopleTableViewCell.self, forCellReuseIdentifier: "NearPeopleTableViewCell")
    }
  
    func toggleBtns(hidden: Bool) {
        mainView.refreshBtn.isHidden = hidden
        mainView.changeBtn.isHidden = hidden
    }
}
extension ReceivedRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearPeopleTableViewCell", for: indexPath) as! NearPeopleTableViewCell
        
        cell.nickLabel.text = receivedList[indexPath.row].nick
        cell.nickView.addGestureRecognizer(getPressGesture())
        cell.nickView.tag = indexPath.row
        cell.nickView.isUserInteractionEnabled = true
        
        cell.requestBtn.backgroundColor = Constants.BaseColor.success
        cell.requestBtn.setTitle("수락하기", for: .normal)
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = -1 - indexPath.row
        
        cell.collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        cell.studyCollectionView.register(DemandStudyCollectionViewCell.self, forCellWithReuseIdentifier: "DemandStudyCollectionViewCell")
        print("index: \(indexPath.row) - \(receivedList[indexPath.row].nick) - \(receivedList[indexPath.row].studylist.count)")
        
        cell.studyCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = cell.studyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        cell.studyCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !receivedList[indexPath.row].expanded {
            return 260
        } else {
            return 700
        }
    }
}

extension ReceivedRequestViewController: UIGestureRecognizerDelegate {
    
    fileprivate func getPressGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePress(gestureRecognizer:)))
        return tap
    }
    
    @objc func handlePress(gestureRecognizer: UITapGestureRecognizer) {
        let nickview: UIView = gestureRecognizer.view!
        receivedList[nickview.tag].expanded = !receivedList[nickview.tag].expanded
        mainView.mainTableView.reloadData()
    }
    
}

extension ReceivedRequestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        if index < 0 {
            return buttonTitle.count
        } else {
            print("tag: \(index), count: \(receivedList[collectionView.tag].studylist.count)")
            return receivedList[collectionView.tag].studylist.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = collectionView.tag
        if index < 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as? TitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.titleBtn.setTitle("\(buttonTitle[indexPath.item])", for: .normal)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemandStudyCollectionViewCell", for: indexPath) as? DemandStudyCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.titleBtn.setTitle("\(receivedList[collectionView.tag].studylist[indexPath.item])", for: .normal)
            return cell
            
        }
    }
}
