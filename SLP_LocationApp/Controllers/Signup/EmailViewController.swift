//
//  EmailViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit

final class EmailViewController: BaseViewController, UITextFieldDelegate {
    
    var mainView = EmailView()
    
    var nickname = ""
    var birth: Date = Date()
    var phoneNumber = ""
    var FCMtoken = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textField.becomeFirstResponder()
        mainView.textField.delegate = self
        mainView.textField.addTarget(self, action: #selector(EmailViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.black
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
        
        mainView.textField.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if isValidEmail(testStr: mainView.textField.text!) {
            mainView.sendBtn.fill()
        } else {
            mainView.sendBtn.disable()
        }
      }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendBtnClicked() {
        if isValidEmail(testStr: mainView.textField.text!) {
            let vc = GenderViewController()
            vc.phoneNumber = phoneNumber
            vc.FCMtoken = FCMtoken
            vc.nickname = nickname
            vc.birth = birth
            vc.emailAddress = mainView.textField.text!
            self.transition(vc, transitionStyle: .push)
        } else {
            showToast(message: "이메일 형식이 올바르지 않습니다.")
        }
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
