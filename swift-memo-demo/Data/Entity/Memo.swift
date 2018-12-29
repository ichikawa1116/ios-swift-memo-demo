//
//  Memo.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import RealmSwift
import Foundation

final class Memo: Object {
    
    @objc dynamic var memoID = 0
    @objc dynamic var title = ""
    @objc dynamic var contents = ""
    @objc dynamic var updateDate: Date?
    
    override static func primaryKey() -> String? {
        return "memoID"
    }
}
