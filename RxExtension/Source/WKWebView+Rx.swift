//
//  WKWebView+Rx.swift
//  RxExtension
//
//  Created by Charlie Cai on 8/8/20.
//  Copyright © 2020 tickboxs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import WebKit

extension Reactive where Base:WKWebView {
    var estimatedProgress:Observable<Double> {
        get {
            return base.rx
                .observe(Double.self, "estimatedProgress", options: [.initial,.new], retainSelf: false)
                .map { $0 ?? 0 }
        }
    }
}
