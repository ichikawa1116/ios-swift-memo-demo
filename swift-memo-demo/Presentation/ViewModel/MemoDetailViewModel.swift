//
//  MemoDetailViewModel.swift
//  swift-memo-demo
//
//  Created on 2018/12/08.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MemoDetailViewModel: ViewModelType {
    
    private let saveMemoUseCase: SaveMemoUseCase
    private let folder: Folder
    private let router: MemoDetailRouter
    
    init(useCase: SaveMemoUseCase,
         folder: Folder,
         router: MemoDetailRouter){
        self.saveMemoUseCase = useCase
        self.folder = folder
        self.router = router
    }
    
    struct Input {
        let viewWillAppear: Observable<()>
        let tapBackButton: Observable<String?>
    }
    
    struct Output {
        let didGoBack: Observable<()>
    }
    
    
    func transform(input: Input) -> Output {
        
//        let didSaveMemo = input.saveMemoTrigger
//            .flatMap { [weak self] _ -> Observable<[()]> in
//
//                return
//        }
        
        let didGoBack = input.tapBackButton.take(1).flatMap { text -> Observable<()> in
            self.saveMemoUseCase.save(memo: text, in: self.folder).flatMap { _ -> Observable<()> in
                self.router.goBack()
            }
        }
        
        return Output(didGoBack: didGoBack)
        
    }
    
    
}
