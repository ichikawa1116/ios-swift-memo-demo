//
//  FolderService.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift

protocol FolderService {
    
    func add(title: String) -> Observable<()>
    
    func fetchFolders() -> Observable<[Folder]>
}

struct FolderServiceImpl: FolderService {
    
    private var dao: FolderDao!
    
    init(dao: FolderDao) {
        self.dao = dao
    }
    
    /// フォルダを追加
    ///
    /// - Parameter title: フォルダのタイトル
    /// - Returns: フォルダの追加完了
    func add(title: String) -> Observable<()> {
        return dao.add(title: title)
    }
    
    /// すべてのメモを取得する
    ///
    /// - Returns: フォルダ一覧
    func fetchFolders() -> Observable<[Folder]> {
        return dao.fetchFolders()
    }
}
