//
//  FolderListDataProvider.swift
//  swift-memo-demo
//
//  Created on 2018/11/11.
//  Copyright © 2018 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// フォルダ一覧TableView DataSourceクラス
class FolderListDataProvider: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    // observedEventの要素を設定
    typealias Element = [Folder]
    var items: [Folder] = []
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell",
                                                            for: indexPath) as! FolderCell
        let element = items[indexPath.row]
        cell.titleLabel.text = element.title
        return cell
    }
    
    // MARK: RxTableViewDataSourceType
    
    func tableView(_ tableView: UITableView,
                   observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource.items = element
            tableView.reloadData()}
            .on(observedEvent)
    }

}


