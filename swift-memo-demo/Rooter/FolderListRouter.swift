//
//  RootRouter.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol FolderListRouter {
    //func goToNext()
    
    func promptFor<Action: CustomStringConvertible>(_ message: String,
                                                    cancelAction: Action,
                                                    actions: [Action]) -> Observable<(Action, String?)>
}

class FolderListRouterImpl: FolderListRouter {
    
    private weak var vc: FolderListViewController?
    
    init(_ viewController: FolderListViewController) {
        vc = viewController
    }
    
    func promptFor<Action : CustomStringConvertible>(_ message: String,
                                                     cancelAction: Action,
                                                     actions: [Action]) -> Observable<(Action, String?)> {
        return Observable.create { observer in
            let alertView = UIAlertController(title: "フォルダのタイトル",
                                              message: message,
                                              preferredStyle: .alert)
            
            // TextFieldをつける
            alertView.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                textField.placeholder = "タイトルを入力してください。"
            })
            
            // キャンセルアクション
            alertView.addAction(UIAlertAction(title: cancelAction.description,
                                              style: .cancel) { _ in
                observer.on(.next((cancelAction, nil)))
            })
            
            // その他のアクション
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description,
                                                  style: .default) { _ in
                    guard let textField = alertView.textFields?.first,
                        let text = textField.text else {
                        return observer.on(.next((cancelAction, nil)))
                    }
                    observer.on(.next((action, text) as (Action, String?)))
                })
            }
            self.vc?.present(alertView, animated: true, completion: nil)
            
            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
    }
    
}

