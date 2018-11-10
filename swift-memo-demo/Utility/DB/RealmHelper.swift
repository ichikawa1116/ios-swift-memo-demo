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

final class RealmDaoHelper <T: RealmSwift.Object> {
    let realm: Realm
    
    init() {
        do {
            try realm = Realm()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        
        do {
            let realm = try Realm()
            return (realm.objects(T.self).max(ofProperty: key) as Int? ?? 0) + 1
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    /**
     * 全件取得
     */
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
    
    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /**
     * 最後のレコードを取得
     */
//    func findLast() -> T? {
//        return findAll().last
//    }
    
    /**
     * レコード追加を取得
     */
    func add(data: T) -> Observable<()> {
        do {
            try realm.write {
                realm.add(data)
            }
            return Observable.just(())
        } catch let error as NSError {
            print(error.description)
            return Observable.error(error)
        }
    }
    
    /**
     * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
     */
    @discardableResult
    func update(data: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(data, update: true)
            }
            return true
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }
    
    /**
     * レコード削除
     */
    func delete(data: T) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
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

