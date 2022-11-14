//
//  AuthViewController.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/07.
//
import UIKit
import SnapKit
import AnyFormatKit

class AuthViewController: BaseViewController, UITextFieldDelegate {
        
    var mainView = AuthView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textField.delegate = self
        
        mainView.sendBtn.addTarget(self, action: #selector(sendBtnClicked), for: .touchUpInside)
    }

    
    //유효성 검사
    func validatePhone(phone: String) {
        let pattern = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: phone, options: [], range: NSRange(location: 0, length: phone.count)) {
            mainView.sendBtn.backgroundColor = Constants.BaseColor.green
        } else {
            mainView.sendBtn.backgroundColor = Constants.BaseColor.gray6
        }
    }
    
    //하이픈 자동생성
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return false
        }

        let formatter = DefaultTextInputFormatter(textPattern: "###-####-####")
        let result = formatter.formatInput(currentText: text, range: range, replacementString: string)
        textField.text = result.formattedText
        validatePhone(phone: textField.text!)
        let position = textField.position(from: textField.beginningOfDocument, offset: result.caretBeginOffset)!
        textField.selectedTextRange = textField.textRange(from: position, to: position)
        return false
    }
    
    @objc func sendBtnClicked() {
        mainView.textField.resignFirstResponder()
        
        //파이어베이스 인증
        if let text = mainView.textField.text, !text.isEmpty {
            let number = "+82\(text)"
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                print("시작")
                print("success: \(success)")
                guard success else { return }
                DispatchQueue.main.async {
                    print("transition")
                    let vc = SMSCodeViewController()
                    vc.phoneNumber = number
                    
                    self?.transition(vc, transitionStyle: .presentFullScreen)
                    print("완료")
                }
            }
        }
    }    
}

