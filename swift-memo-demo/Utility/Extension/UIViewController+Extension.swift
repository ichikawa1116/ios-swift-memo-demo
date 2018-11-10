//
//  UIViewController+Extension.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import RxSwift

//extension UIViewController {
//    func showAlart<Type>(title: String?, message: String? = nil, cancelMessage: String = "キャンセル", actions: [AlertAction<Type>]) -> Observable<Type> {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        return alert.addAction(actions: actions, cancelMessage: cancelMessage, cancelAction: nil)
//            .do(onSubscribed: { [weak self] in
//                self?.present(alert, animated: true, completion: nil)
//            })
//    }
//}
