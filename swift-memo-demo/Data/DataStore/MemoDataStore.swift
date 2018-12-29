//
//  MemoDataStore.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/11/26.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import Foundation
import RxSwift

protocol MemoDataStore {
    
    func add(title: String, contents: String) -> Observable<Int>
    
    func update(memo: Memo) -> Observable<()>
    
    func findBy(id: Int) -> Observable<Memo?>
}

struct MemoDataStoreDBImpl: MemoDataStore {
    
    let db = RealmDaoHelper<Memo>()
    
    func add(title: String, contents: String) -> Observable<Int> {
        let object = Memo()
        object.memoID = db.newId()!
        object.title = title
        object.contents = contents
        object.updateDate = Date()
        return db.add(data: object).map { _ in object.memoID }
    }
    
    func update(memo: Memo) -> Observable<()> {
        return db.update(data: memo)
    }
    
    func findBy(id: Int) -> Observable<Memo?> {
        return db.findFirstObservable(key: id as AnyObject)
    }
    
}
