//
//  UIAlertController+Rx.swift
//  RxExtension
//
//  Created by Charlie Cai on 8/8/20.
//  Copyright © 2020 tickboxs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base:UIAlertController {
    func show(vc:UIViewController,actions:[(String,UIAlertAction.Style)],completion:(()-> Void)? = nil) -> Observable<Int> {
        return Observable.create { [unowned base] (observer) -> Disposable in
            for (index,action) in actions.enumerated() {
                base.addAction(UIAlertAction(title: action.0, style: action.1, handler: { (action) in
                    observer.onNext(index)
                    observer.onCompleted()
                }))
            }
            vc.present(base, animated: true, completion: completion)
            return Disposables.create()
        }
    }
}

