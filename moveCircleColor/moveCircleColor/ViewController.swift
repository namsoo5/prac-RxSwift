//
//  ViewController.swift
//  moveCircleColor
//
//  Created by 남수김 on 12/08/2019.
//  Copyright © 2019 ns. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var circleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        // 원 모양의 뷰를 그립니다
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMove(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func circleMove(_ recognizer: UIPanGestureRecognizer){
        let location = recognizer.location(in: view)
            UIView.animate(withDuration: TimeInterval(0.1)) {
            self.circleView.center = location
        }
    }

}

