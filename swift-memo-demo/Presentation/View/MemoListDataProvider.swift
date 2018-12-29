//
//  MemoListDataProvider.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/11/24.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// タスク一覧TableView DataSourceクラス
class MemoListDataProvider: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    // observedEventの要素を設定
    typealias Element = [Memo]
    var items: [Memo] = []
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell",
                                                 for: indexPath) as! MemoCell
//        let element = items[indexPath.row]
//        cell.memoTitleLabel.text = element.title
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
