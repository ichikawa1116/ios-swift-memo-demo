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

//TODO: プロトコルに準拠
final class FolderListViewModel: ViewModelType {

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
        let didCreateFolder: Observable<()>
        let folders: Observable<[Folder]>
    }
    
    //TODO: selfのアンラップとベタがき修正
    func transform(input: Input) -> Output {

        let isFolderTitleConfirmed = input.createFolderTrigger
            .asObservable()
            .flatMap { [weak self] aaa  -> Observable<(Action, String?)> in
                guard let _self = self else {
                    return Observable.just((Action.Cancel("Cancel"), ""))
                }
                return (_self.router.promptFor("タイトルを入力してください",
                                                cancelAction: Action.Cancel("Cancel"),
                                                actions: [Action.Confirm("OK")]))
            }
            .flatMap{ (action, text) -> Observable<String?> in
                switch action {
                case .Cancel(let cancelt):
                    print(cancelt)
                    return Observable.just(nil)
                case .Confirm(let confirm):
                    print("\(confirm): \(String(describing: text))")
                    return Observable.just(text)
                }
                
        }
        
        let didCreateFolder = isFolderTitleConfirmed
            .flatMap { [weak self] result -> Observable<()> in
                guard let _self = self else {
                    return Observable.empty()
                }
                
                if let result = result {
                    return _self.service.add(title: result)
                } else {
                    return Observable.empty()
                }
        }
        
        let folders: Observable<()> = Observable.merge(input.refreshTrigger, didCreateFolder)
        
        let refreshedFolders =  folders.flatMap { [weak self] _ -> Observable<[Folder]> in
                guard let _self = self else {
                    return Observable.empty()
                }
                return _self.service.fetchFolders()
        }
        
        return Output(didCreateFolder: didCreateFolder,
                      folders: refreshedFolders)
    }
}
