//
//  FolderRepository.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/12/08.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import Foundation
import RxSwift

protocol FolderRepository {
    
    func add(title: String) -> Observable<()>
    
    func fetch() -> Observable<[Folder]>
    
    func fetchMemos(folderID: Int) -> Observable<[Memo]>
    
    func update(folder: Folder) -> Observable<()>
}

struct FolderRepositoryImpl: FolderRepository {
    
    private var dataStore: FolderDataStore
    
    init(dataStore: FolderDataStore) {
        self.dataStore = dataStore
    }
    
    func add(title: String) -> Observable<()> {
        return dataStore.add(title: title)
    }
    
    func fetch() -> Observable<[Folder]> {
        return dataStore.fetchFolders()
    }
    
    func fetchMemos(folderID: Int) -> Observable<[Memo]> {
        return dataStore.fetchMemos(folderID: folderID)
    }
    
    func update(folder: Folder) -> Observable<()>{
        return dataStore.update(folder: folder)
    }
}

