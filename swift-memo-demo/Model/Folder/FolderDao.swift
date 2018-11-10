//
//  FolderDao.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import RxSwift

protocol FolderDao {
    func add(title: String) -> Observable<()>
    func fetchFolders() -> Observable<[Folder]>
}

struct FolderDaoImpl: FolderDao{
    
    let dao = RealmDaoHelper<Folder>()

    func add(title: String) -> Observable<()> {
        let object = Folder()
        object.folderID = dao.newId()!
        object.title = title
        object.updateDate = Date()
        return dao.add(data: object)
    }
    
    func fetchFolders() -> Observable<[Folder]> {
        
        
        return dao.findAll().map ({Array($0)})
    }
    
}
