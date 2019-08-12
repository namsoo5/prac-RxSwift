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
import RxOptional

class ViewController: UIViewController {

    var circleView: UIView!
    var disposebag = DisposeBag()
    let circleViewModel = CircleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        // 원 모양의 뷰를 그립니다
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMove(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
        
        circleView.rx.observe(CGPoint.self, "center")
            .filterNil()
            .bind(to: circleViewModel.centerObservable)
            .disposed(by: disposebag)

        //뷰모델의 새로운 색을 얻기위해 backgroundColorObservable구독
        circleViewModel.backgroundColorObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] background in
                UIView.animate(withDuration: TimeInterval(0.1)) {
                    self?.circleView.backgroundColor = background
                    
                    let r = background.components.red
                    let g = background.components.green
                    let b = background.components.blue
                
//                    원이보일수 있도록 다른 색으로 바꾸기
                    let viewBackground: UIColor = UIColor.init(red: 1-r.truncatingRemainder(dividingBy: 0.4), green: 1-g.truncatingRemainder(dividingBy: 0.4), blue: 1-b.truncatingRemainder(dividingBy: 0.4), alpha: 1.0)

//                    원과 배경색이다를때 변경
                    if background != viewBackground {
                        self?.view.backgroundColor = viewBackground
                    }
                }
            })
        .disposed(by: disposebag)
    
        
        
    }

    @objc func circleMove(_ recognizer: UIPanGestureRecognizer){
        let location = recognizer.location(in: view)
            UIView.animate(withDuration: TimeInterval(0.1)) {
            self.circleView.center = location
        }
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    //UIColor에서 rgb값 뽑아내기
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}
