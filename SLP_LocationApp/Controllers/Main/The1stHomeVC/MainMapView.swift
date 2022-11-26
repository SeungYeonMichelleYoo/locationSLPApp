//
//  MainMapView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/08.
//
import UIKit
import SnapKit
import MapKit

class MainMapView: BaseView {
    
    lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 50, maxCenterCoordinateDistance: 30000)
        return view
    }()
    
    lazy var genderStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalBtn, maleBtn, femaleBtn])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    lazy var totalBtn: UIButton = {
        let view = UIButton()
        view.setTitle("전체", for: .normal)
        view.titleLabel?.font = UIFont.font(.Title3_M14)
        view.fill()
        return view
    }()
    
    lazy var maleBtn: UIButton = {
        let view = UIButton()
        view.setTitle("남자", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.font(.Title4_R14)
        view.inactive()
        view.layer.borderWidth = 0
        return view
    }()
    
    lazy var femaleBtn: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.font(.Title4_R14)
        view.inactive()
        view.layer.borderWidth = 0
        return view
    }()
    
    lazy var currentlocationBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "current"), for: .normal)
        return view
    }()
        
    lazy var centerpinImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "centerpin")
        return view
    }()
    
    lazy var floatingBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "floatingBtn_search"), for: .normal)
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [mapView, genderStackView, currentlocationBtn, centerpinImg, floatingBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        genderStackView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        totalBtn.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        currentlocationBtn.snp.makeConstraints { make in
            make.top.equalTo(genderStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
        
        centerpinImg.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(35)
            make.height.equalTo(46)
        }
        
        floatingBtn.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(64)
        }
    }
}
