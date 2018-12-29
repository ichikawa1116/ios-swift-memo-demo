//
//  MemoListViewModel.swift
//  swift-memo-demo
//
//  Created on 2018/11/24.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MemoListViewModel: ViewModelType {
    
    private let saveMemoUseCase: SaveMemoUseCase
    private let fetchMemoUseCase: FetchMemoUseCase
    private let folder: Folder
    private let router: MemoListRouter
    
    init(saveMemoUseCase: SaveMemoUseCase,
         fetchMemoUseCase: FetchMemoUseCase,
         folder: Folder,
         router: MemoListRouter) {
        
        self.saveMemoUseCase = saveMemoUseCase
        self.fetchMemoUseCase = fetchMemoUseCase
        self.folder = folder
        self.router = router
    }

    // TODO: Driverに変換
    struct Input {
        //TODO: Signalにすべき?
        let showMemoDetailTrigger: Observable<IndexPath>
        let addMemoTrigger: Observable<()>
        let refreshTrigger: Observable<()>
        
        //let deleteTrigger: Observable<()>
    }
    
    struct Output {
        let didTapMemo: Observable<IndexPath>
        let didDisplayNextPage: Observable<()>
        let didGetMemoData: Observable<[Memo]>
        //let didDeleteMemo: Observable<()>
    }
    
    func tapMemo(){
        
    }
    
    //TODO: selfのアンラップとベタがき修正
    func transform(input: Input) -> Output {
        
        let add = input.addMemoTrigger.map{ $0 as AnyObject}.debug("タップadd")
        let show = input.showMemoDetailTrigger.map{$0 as AnyObject}
        
        let didTapMemo = input.showMemoDetailTrigger
        
        let didDisplayNextPage = Observable.merge(add, show)
            .asObservable()
            .flatMap { [weak self] bbb -> Observable<()> in
                guard let _self = self else {
                    return Observable.empty()
                }
                return _self.router.goToNext(folder: _self.folder)
        }
        
        let didGetMemoData = input.refreshTrigger
            .asObservable()
            .flatMap { [weak self] _ -> Observable<[Memo]> in
                guard let _self = self else {
                    return Observable.empty()
                }
                return _self.fetchMemoUseCase.fetchMemos(folderID: _self.folder.folderID)
        }
        
//        let didAddMemo = input.addMemoTrigger
//            .asObservable()
//            .flatMap { [weak self] _ -> Observable<()> in
//                guard let _self = self else {
//                    return Observable.empty()
//                }
//                return _self.router.goToNext()
//        }
        
        
        return Output(didTapMemo: didTapMemo, didDisplayNextPage: didDisplayNextPage,
                      didGetMemoData: didGetMemoData)
    }
}

