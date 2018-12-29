//
//  MemoRepository.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/11/26.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import Foundation
import RxSwift

protocol MemoRepository {
    
    func add(title: String, contents: String) -> Observable<Int>
    
    func update(memo: Memo) -> Observable<()>
    
    func findBy(memoId: Int) -> Observable<Memo?>
}

struct MemoRepositoryImpl: MemoRepository {
    
    private var dataStore: MemoDataStore!
    
    init(dataStore: MemoDataStore) {
        self.dataStore = dataStore
    }
    
    func add(title: String, contents: String) -> Observable<Int> {
        return dataStore.add(title: title, contents: contents)
    }
    
    func update(memo: Memo) -> Observable<()> {
        return dataStore.update(memo: memo)
    }
    
    func findBy(memoId: Int) -> Observable<Memo?> {
        return dataStore.findBy(id: memoId)
    }
    
}

