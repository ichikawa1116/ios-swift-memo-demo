//
//  FolderUseCase.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift

protocol FolderUseCase {
    
    func add(title: String) -> Observable<()>
    
    func fetchFolders() -> Observable<[Folder]>
}

struct FolderUseCaseImpl: FolderUseCase {
    
    private var repository: FolderRepository
    
    init(repository: FolderRepository) {
        self.repository = repository
    }
    
    /// フォルダを追加
    ///
    /// - Parameter title: フォルダのタイトル
    /// - Returns: フォルダの追加完了
    func add(title: String) -> Observable<()> {
        return repository.add(title: title)
    }
    
    /// すべてのメモを取得する
    ///
    /// - Returns: フォルダ一覧
    func fetchFolders() -> Observable<[Folder]> {
        return repository.fetch()
    }
}
