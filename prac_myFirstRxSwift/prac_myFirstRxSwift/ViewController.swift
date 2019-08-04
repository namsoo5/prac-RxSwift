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
        
        //input  아이디 입력, 비밀번호 입력
        let idInputOb = idTextField.rx.text.orEmpty.asObservable()
        let idCheckOb = idInputOb.map(checkId)
        
        let pwInputOb = pwTextField.rx.text.orEmpty.asObservable()
        let pwCheckOb = idInputOb.map(checkPw)
        
        //output 상태컬러, 로그인버튼 활성화
        idCheckOb.subscribe(onNext: { b in
            if b {
                self.idColorView.backgroundColor = UIColor.blue
            }else {
                self.idColorView.backgroundColor = UIColor.red
            }
        })
            .disposed(by: disposeBag)
        
        pwCheckOb.subscribe(onNext: { b in
            if b {
                self.pwColorView.backgroundColor = UIColor.blue
            }else {
                self.pwColorView.backgroundColor = UIColor.red
            }
        })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(idCheckOb, pwCheckOb, resultSelector: {$0 && $1})
        .subscribe(onNext: {b in self.loginBtn.isEnabled = b})
        .disposed(by: disposeBag)
        
        
        
        
        /*
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
            .map(checkPw)   // pw 유형체크
            .subscribe(onNext: { s in   // s: true or false
                if s {
                    self.pwColorView.backgroundColor = UIColor.blue
                }else {
                    self.pwColorView.backgroundColor = UIColor.red
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            idTextField.rx.text.orEmpty.map(checkId), //아이디 유형을 체크한 값이 내려옴 true/false
            pwTextField.rx.text.orEmpty.map(checkPw),
            resultSelector: {s1, s2 in s1 && s2}
            )
            .subscribe(onNext: {s in  // s1 && s2 결과값
                self.loginBtn.isEnabled = s
            })
            .disposed(by: disposeBag)
        */
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

