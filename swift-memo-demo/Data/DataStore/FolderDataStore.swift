//
//  FolderDataStore.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/12/08.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import Foundation
import RxSwift

protocol FolderDataStore {
    
    func add(title: String) -> Observable<()>
    func fetchFolders() -> Observable<[Folder]>
    func fetchMemos(folderID: Int) -> Observable<[Memo]>
    func update(folder: Folder) -> Observable<()>
    
}

// TODO: findFirstをメソッドをObservableで返す

// TODO: Observable.emptyを流してはいけない。イベントが流れないため、その後のそ処理が進まない
struct FolderDBImpl: FolderDataStore {
    
    let db = RealmDaoHelper<Folder>()
    
    func add(title: String) -> Observable<()> {
        let object = Folder()
        object.folderID = db.newId()!
        object.title = title
        object.updateDate = Date()
        
        return db.add(data: object)
    }
    
    func update(folder: Folder) -> Observable<()> {
        
        guard let target = db.findFirst(key: folder.folderID as AnyObject ) else {
            return Observable.empty()
        }
        
        let object = Folder()
        object.folderID = target.folderID
        object.title = target.title
        object.updateDate = Date()
        object.memos.append(objectsIn: folder.memos)
        return db.update(data: object)
    }
    
    func fetchFolders() -> Observable<[Folder]> {
        return db.findAll().map ({Array($0)})
    }
    
    func fetchMemos(folderID: Int) -> Observable<[Memo]> {
        // TODO: 一旦強制アンラップ
        return db.findFirstObservable(key: folderID as AnyObject)
            .map{ $0?.memos }
            .map {(Array($0!))}
    }
}

