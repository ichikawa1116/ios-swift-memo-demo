//
//  Task.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import RealmSwift
import Foundation

final class Task: Object {
    
    @objc dynamic var taskID = 0
    @objc dynamic var title = ""
    @objc dynamic var date: Date?
    
    override static func primaryKey() -> String? {
        return "taskID"
    }
}
