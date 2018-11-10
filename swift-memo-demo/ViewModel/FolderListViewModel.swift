//
//  FolderListViewModel.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Action: CustomStringConvertible {
    case Cancel(String)
    case Confirm(String)
    var description: String {
        switch self {
        case .Cancel(let title): return title
        case .Confirm(let title): return title
        }
    }
}

final class FolderListViewModel {

    private let service: FolderService
    private let router: FolderListRouter

    init(service: FolderService, router: FolderListRouter) {
        self.service = service
        self.router = router
    }
    
    struct Input {
        //TODO: Signalにすべき?
        let createFolderTrigger: Driver<()>
        let refreshTrigger: Observable<()>
    }
    
    struct Output {
        let didCreateFolder: Driver<()>
        let folders: Observable<[Folder]>
    }
    
    func transform(input: Input) -> Output {
        // Observable<Action>
        let isFolderTitleConfirmed = input.createFolderTrigger
            .asObservable()
            .flatMap { [weak self] aaa  -> Observable<(Action, String?)> in
                return (self?.router.promptFor("タイトルを入力してください", cancelAction: Action.Cancel("Cancel"), actions: [Action.Confirm("OK")], needText: true))!
            }
            .flatMap{ (action, text) -> Observable<String?> in
                switch action {
                case .Cancel(let cancelt):
                    print(cancelt)
                    return Observable.just(nil)
                case .Confirm(let confirm):
                    print("\(confirm): \(String(describing: text))")
                    return Observable.just(text)
                    // TODO: textFieldどうやって添付する
                    //self?.service.add(title: confirm)
                }
                
        }
        
        let didCreateFolder = isFolderTitleConfirmed
            .flatMap { [weak self] result -> Driver<()> in
                guard let _self = self else {
                    return Driver.empty()
                }
                
                if let result = result {
                    return _self.service.add(title: result).asDriverOnErrorJustComplete()
                    
                } else {
                    return Driver.empty()
                }
        }
        
        let folders = input.refreshTrigger
            .flatMap { [weak self] _ -> Observable<[Folder]> in
                guard let _self = self else {
                    return Observable.empty()
                }
                return _self.service.fetchFolders()
        }
        
    return Output(didCreateFolder: didCreateFolder.asDriverOnErrorJustComplete(),
                  folders: folders)
    }
    
    
}
