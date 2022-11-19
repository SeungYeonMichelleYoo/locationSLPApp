//
//  BirthViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//

import UIKit

class BirthViewController: BaseViewController {
    
    var mainView = BirthView()
    
    var nickname = ""
    var phoneNumber = ""
    var FCMtoken = ""
    
    override func loadView() {
        print("loadview")
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.black

        datePickerConfigureUI()
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
    }
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendBtnClicked() {
        if checkAge(birth: mainView.datePicker.date) {
            let vc = EmailViewController()
            vc.phoneNumber = phoneNumber
            vc.FCMtoken = FCMtoken
            vc.nickname = nickname
            vc.birth = mainView.datePicker.date
            self.transition(vc, transitionStyle: .push)
        } else {
            showToast(message: "새싹스터디는 만 17세 이상만 사용할 수 있습니다.")
        }
    }
    
    private func datePickerConfigureUI() {
        setAttributes()
    }
    
    private func setAttributes() {
        mainView.datePicker.datePickerMode = .date
        mainView.datePicker.locale = Locale(identifier: "ko-KR")
        mainView.datePicker.timeZone = .autoupdatingCurrent
        mainView.datePicker.maximumDate = Date()
        mainView.datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    }
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        let date: Date = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM"
        let month: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: date)
        
        mainView.yeartextField.text = year
        mainView.monthtextField.text = month
        mainView.daytextField.text = day
        
        mainView.sendBtn.fill()
    }
    
    func checkAge(birth: Date) -> Bool {
        let now = Date()
        
        if now.getYear() - birth.getYear() > 17 {
            return true
        } else if now.getYear() - birth.getYear() == 17 {
            if now.getMonth() < birth.getMonth() {
                return false
            } else if now.getMonth() == birth.getMonth() {
                if now.getDay() < birth.getDay() {
                    return false
                } else {
                    return true
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

