//
//  ShopBackgroundViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/15.
//
import UIKit

class ShopBackgroundViewController: BaseViewController {
        
    var mainView = ShopBackgroundView()
    
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
        setupTableview()
    }
    
    func setupTableview() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(ShopBackgroundTableViewCell.self, forCellReuseIdentifier: "ShopBackgroundTableViewCell")
    }
}

extension ShopBackgroundViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backgroundName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopBackgroundTableViewCell", for: indexPath) as! ShopBackgroundTableViewCell
        
        cell.titleLabel.text = backgroundName[indexPath.row]
        cell.contentLabel.text = backgroundDescription[indexPath.row]
        cell.backgroundImg.image = BackgroundImage.image(level: indexPath.row)
        return cell
    }
}

