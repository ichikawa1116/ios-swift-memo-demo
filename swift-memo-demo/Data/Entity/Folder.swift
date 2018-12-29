//
//  Folder.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import RealmSwift
import Foundation

final class Folder: Object {
    @objc dynamic var folderID = 0
    @objc dynamic var title = ""
    @objc dynamic var updateDate: Date?
    let memos = List<Memo>()
    
    var memoCount: String {
        return "\(memos.count)"
    }
    
    override static func primaryKey() -> String? {
        return "folderID"
    }
    
}
