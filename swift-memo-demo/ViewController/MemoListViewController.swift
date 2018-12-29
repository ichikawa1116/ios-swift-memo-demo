//
//  MemoListViewController.swift
//  swift-memo-demo
//
//  Created on 2018/11/24.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MemoListViewController: UIViewController {

    @IBOutlet weak var memoListTableView: UITableView!
    private let disposeBag = DisposeBag()
    private let provider = MemoListDataProvider()
    private var viewModel: MemoListViewModel!
    private var folder: Folder!
    private let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        bindViewModel()
    }
    
    func inject(viewModel: MemoListViewModel,
                folder: Folder){
        self.viewModel = viewModel
        self.folder = folder
    }
    
    func setupTable() {
        memoListTableView.delegate = self
        memoListTableView.dataSource = provider
        memoListTableView.register (UINib(nibName: String(describing: MemoCell.self),
                                          bundle: nil),forCellReuseIdentifier:"MemoCell")
        
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func bindViewModel() {
        
        memoListTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let showDetailTrigger = memoListTableView
            .rx
            .itemSelected
            .asObservable
        
        
        let refreshTrigger = rx.sentMessage(#selector(viewWillAppear)).take(1).mapToVoid()
        let input = MemoListViewModel.Input(showMemoDetailTrigger: showDetailTrigger(),
                                            addMemoTrigger: rightBarButtonItem.rx.tap.asObservable(),
                                            refreshTrigger: refreshTrigger)
        
        let output = viewModel.transform(input: input)
        /*カスタムセルを使用しているため、cellTypeをセットする必要がある。
         下記の方法はtableViewにバインドするシンプルな方法だが、ヘッダーや編集モードの設定ができない*/
        
        //MARK: memo: シンプルなバインド方法
        
        //  output.folders.bind(to: folderListTableView.rx.items(cellIdentifier: "FolderCell", cellType: FolderCell.self)){ _, element, cell in
        //  cell.titleLabel.text = element.title
        //  }.disposed(by: disposeBag)
        
        //output.folders.bind(to: provider.items)
        output.didGetMemoData.subscribe(onNext: {[weak self] items in
            self?.provider.items = items
            self?.memoListTableView.reloadData()
        }).disposed(by: disposeBag)
        
        
        
        memoListTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        
        
        output.didTapMemo.subscribe(onNext: { indexPath in
            self.memoListTableView.deselectRow(at: indexPath, animated: false)
        }).disposed(by: disposeBag)
        
        output.didDisplayNextPage.subscribe(onNext:{
            
        }).disposed(by: self.disposeBag)
        
        output.didGetMemoData.subscribe().disposed(by: self.disposeBag)
        
    }
}


extension MemoListViewController: UITableViewDelegate {
    
}


