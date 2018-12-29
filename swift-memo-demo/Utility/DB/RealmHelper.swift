//
//  RealmHelper.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018  All rights reserved.
//

import Foundation
import RxSwift

import RealmSwift

// TODO: Observableを返却するように修正
final class RealmDaoHelper <T: RealmSwift.Object> {
    let realm: Realm
    
    init() {
        do {
            try realm = Realm()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    /// プライマリキーを取得
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            return (realm.objects(T.self).max(ofProperty: key) as Int? ?? 0) + 1
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    /// 全件取得
    func findAll() -> Observable<Results<T>> {
        return Observable.just(realm.objects(T.self))
    }
    
    
     /// 全件取得
    func findAll(key: AnyObject, value: AnyObject) -> Results<T> {
        return realm.objects(T.self).filter("\(key) == \(value)")
    }
    
    /**
     * 1件目のみ取得
     */
//    func findFirst() -> T? {
//        return findAll().first
//    }
    
    /// 指定キーのレコード取得
    func findFirstObservable(key: AnyObject) -> Observable<T?> {
        return Observable.create { observer in
            do {
                try self.realm.write {
                    let objects = self.realm.object(
                        ofType: T.self,
                        forPrimaryKey: key)
                    observer.onNext(objects)
                    observer.onCompleted()
                }
            } catch let error as NSError {
                print(error.description)
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func findFirst(key: AnyObject) -> T? {
        return self.realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    
    /// レコード追加を取得
    func add(data: T) -> Observable<()> {
        return Observable.create { observer in
            do {
                try self.realm.write {
                    self.realm.add(data)
                    try self.realm.commitWrite()
                }
                observer.onNext(())
                observer.onCompleted()
            } catch let error as NSError {
                print("エラー\(error.description)")
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
     */
    @discardableResult
    /// アップデート
    func update(data: T, block:(() -> Void)? = nil) -> Observable<()> {
        return Observable.create { observer in
            do {
                // TODO: 同じスレッド内ですでに書き込みトランザクションが開始している場合に
                //       例外が発生。　改善策を検討中
                if (self.realm.isInWriteTransaction) {
                    try self.realm.commitWrite()
                }
                try self.realm.write {
                    block?()
                    self.realm.add(data, update: true)
                    try self.realm.commitWrite()
                }
                observer.onNext(())
                
                observer.onCompleted()
            } catch let error as NSError {
                print(error.description)
                observer.onError(error)
            }
            return Disposables.create()
        }
            
    }
    
    /// 削除
    func delete(data: T) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    /// 全件削除
    func deleteAll(key: AnyObject, value: AnyObject) {
        let objs = findAll(key: key, value: value)
        
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    

    /// 全件削除
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
}

