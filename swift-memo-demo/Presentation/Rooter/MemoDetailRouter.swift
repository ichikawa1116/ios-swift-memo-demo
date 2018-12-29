//
//  MemoDetailRouter.swift
//  swift-memo-demo
//
//  Created on 2018/12/08.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol MemoDetailRouter {
    
    func goBack() -> Observable<()>
}

class MemoDetailRouterImpl: MemoDetailRouter {
    
    private weak var vc: MemoDetailViewController?
    
    init(_ viewController: MemoDetailViewController) {
        vc = viewController
    }
    
    func goBack() -> Observable<()> {
        self.vc?.navigationController?.popViewController(animated: true)
        return Observable.just(())
    }
    
}



