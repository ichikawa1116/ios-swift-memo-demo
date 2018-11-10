//
//  Observable+Extension.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
