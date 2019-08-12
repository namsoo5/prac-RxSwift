//
//  File.swift
//  moveCircleColor
//
//  Created by 남수김 on 12/08/2019.
//  Copyright © 2019 ns. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CircleViewModel {
    var centerObservable: BehaviorSubject<CGPoint> = BehaviorSubject(value: CGPoint(x: 0.0, y: 0.0))
    var backgroundColorObservable: BehaviorSubject<UIColor> = BehaviorSubject(value: UIColor.black)
    var disposeBag = DisposeBag()
    
    init() {
        self.setup()
    }
    
    func setup() {
        centerObservable.map(pointToColor)
        .bind(to: backgroundColorObservable)
        .disposed(by: disposeBag)
    
    }
    
    func pointToColor(_ center: CGPoint) -> UIColor{
    
        var r: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255) / 255.0)
        let g: CGFloat = 0.1
        let b: CGFloat = 0.1
        let rs = String(format: "%.1f", r)
        r = stringToCgFloat(rs)
        return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    func stringToCgFloat(_ s: String) -> CGFloat {
        let float = Float(s)!
        return CGFloat(float)
    }
}
