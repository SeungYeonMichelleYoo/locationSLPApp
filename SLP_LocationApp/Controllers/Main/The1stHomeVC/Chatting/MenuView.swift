//
//  MenuView.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/12/21.
//
import UIKit
import SnapKit

class MenuView: BaseView {
    
    lazy var bigStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [reportStackView, cancelStackView, reviewStackView])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 0
        return view
    }()
    
    lazy var reportStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [reportImg, reportLabel])
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var reportImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "report")
        return view
    }()
    
    lazy var reportLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 신고"
        label.textColor = .black
        label.font = UIFont.font(.Title3_M14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var cancelStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cancelImg, cancelLabel])
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var cancelImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cancel_match")
        return view
    }()
    
    lazy var cancelLabel: UILabel = {
        let label = UILabel()
        label.text = "스터디 취소"
        label.textColor = .black
        label.font = UIFont.font(.Title3_M14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var reviewStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [reviewImg, reviewLabel])
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var reviewImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "write")
        return view
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰 등록"
        label.textColor = .black
        label.font = UIFont.font(.Title3_M14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(bigStackView)
    }
    
    override func setConstraints() {
        bigStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
