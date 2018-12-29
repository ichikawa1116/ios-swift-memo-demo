//
//  MemoDetailUseCase.swift
//  swift-memo-demo
//
//  Created on 2018/11/26.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift

protocol SaveMemoUseCase {
    
    func save(memo: String?, in folder: Folder) -> Observable<()>
    
    //func fetchMemo() -> Observable<[Memo]>
}

struct SaveMemoUseCaseImpl: SaveMemoUseCase {
    
    private let memoRepository: MemoRepository
    private let folderRepository: FolderRepository
    
    init(memoRepository: MemoRepository,
         folderRepository: FolderRepository) {
        self.memoRepository = memoRepository
        self.folderRepository = folderRepository
    }
    
    func save(memo: String?, in folder: Folder) -> Observable<()> {
        
        guard let memo = memo else {
            // TODO: 空文字かどうかのチェックメソッド
            return Observable.empty()
        }
        
        let components = separateTitleFromMemo(memo: memo)
        
        return memoRepository.add(
            title: components.title,
            contents: components.contents)
            .flatMap { memoId -> Observable<()> in
                return self.memoRepository.findBy(memoId: memoId)
                    .flatMap { memo -> Observable<()> in
                        guard let memo = memo else {
                            // TODO: エラー
                            return Observable.just(())
                        }
                        folder.memos.append(memo)
                        return self.folderRepository.update(folder: folder)
                    }
            }
    }

    private func separateTitleFromMemo(memo: String) -> (title: String, contents: String) {
        let lines = memo.lines
        
        guard let title = lines.first else {
            return (title: "", contents: "")
        }
        let contents = lines.dropFirst().joined()
        return (title: title, contents: contents)
    }
    
}

