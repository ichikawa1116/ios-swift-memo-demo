//
//  TaskDao.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

protocol TaskDao {
    
}

struct TaskDaoImpl: TaskDao {
    
    static let dao = RealmDaoHelper<Task>()
}
