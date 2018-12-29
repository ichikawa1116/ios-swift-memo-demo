//
//  MemoListRouter.swift
//  swift-memo-demo
//
//  Created on 2018/11/24.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol MemoListRouter {
    func goToNext(folder: Folder) -> Observable<()>
}

class MemoListRouterImpl: MemoListRouter {
    
    private weak var vc: MemoListViewController?
    
    init(_ viewController: MemoListViewController) {
        vc = viewController
    }
    
    func goToNext(folder: Folder) -> Observable<()> {
        self.vc?.navigationController?.pushViewController(MemoDetailBuilder.build(folder: folder), animated: true)
        return Observable.just(())
    }
    
}


