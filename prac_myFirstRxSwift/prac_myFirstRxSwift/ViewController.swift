//
//  ViewController.swift
//  prac_myFirstRxSwift
//
//  Created by 남수김 on 04/08/2019.
//  Copyright © 2019 ns. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwColorView: UIView!
    @IBOutlet weak var idColorView: UIView!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    private func bindUI() {
        
        idTextField.rx.text.orEmpty
            .map(checkId)   // 아이디 유형체크
            .subscribe(onNext: { s in   // s: true or false
                if s {
                    self.idColorView.backgroundColor = UIColor.blue
                }else {
                    self.idColorView.backgroundColor = UIColor.red
                }
            })
            .disposed(by: disposeBag)
        
        
        pwTextField.rx.text.orEmpty
            .map(checkPw)   // 아이디 유형체크
            .subscribe(onNext: { s in   // s: true or false
                if s {
                    self.pwColorView.backgroundColor = UIColor.blue
                }else {
                    self.pwColorView.backgroundColor = UIColor.red
                }
            })
            .disposed(by: disposeBag)
    }

    @IBAction func loginBtnClick(_ sender: Any) {
        
    }
    
    private func checkId(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPw(_ pw: String) -> Bool {
        return pw.count > 5
    }
}

