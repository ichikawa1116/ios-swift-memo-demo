//
//  UIAlartController+Extension.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

//import UIKit
//import RxSwift
//
//// MARK: - Action
//internal struct AlertAction<Type: Equatable> {
//    internal let title: String
//    internal let actionType: Type
//    internal let style: UIAlertAction.Style
//}
//
//// MARK: - UIAlertController
//internal extension UIAlertController {
//
//    enum AnimalSelectAction: String {
//        case dog, cat, rabbit, panda
//
//        static var AnimalSelectActions: [AnimalSelectAction] {
//            return [.dog, .cat, .rabbit, .panda]
//        }
//    }
//
//
//    internal func addAction<Type>(actions: [AlertAction<Type>], cancelMessage: String, cancelAction: ((UIAlertAction) -> Void)? = nil) -> Observable<Type> {
//        return Observable.create { [weak self] observer in
//            actions.map { action in
//                return UIAlertAction(title: action.title, style: action.style) { _ in
//                    observer.onNext(action.actionType)
//                    observer.onCompleted()
//                }
//                }.forEach { action in
//                    self?.addAction(action)
//            }
//
//            self?.addAction(UIAlertAction(title: cancelMessage, style: .cancel) {
//                cancelAction?($0)
//                observer.onCompleted()
//            })
//
//            return Disposables.create {
//                self?.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//}
//
