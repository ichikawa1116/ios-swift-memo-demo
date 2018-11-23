//
//  FolderListViewController.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FolderListViewController: UIViewController {

    @IBOutlet weak var folderListTableView: UITableView!
    @IBOutlet weak var addFolderButton: UIBarButtonItem!
    private var viewModel: FolderListViewModel!
    private let disposeBag = DisposeBag()
    private let provider = FolderListDataProvider()
    let textfield = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        bindViewModel()
    }
    
    func setupTable() {
        folderListTableView.delegate = self
        folderListTableView.dataSource = provider
        folderListTableView.register (UINib(nibName: String(describing: FolderCell.self), bundle: nil),forCellReuseIdentifier:"FolderCell")
        
        folderListTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // ここで画面遷移する
        folderListTableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.folderListTableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)

    }
    
    func bindViewModel() {
        let refreshTrigger = rx.sentMessage(#selector(viewWillAppear)).take(1).mapToVoid()
        let createFolderTrigger = addFolderButton.rx.tap.asDriver()
        let input = FolderListViewModel.Input(createFolderTrigger: createFolderTrigger,
                                              refreshTrigger: refreshTrigger)
        
        let output = viewModel.transform(input: input)
        
//        output.didCreateFolder.subscribe(onNext:{
//            print("folder is created")
//        }).disposed(by: disposeBag)
        
            /*カスタムセルを使用しているため、cellTypeをセットする必要がある。
             下記の方法はtableViewにバインドするシンプルな方法だが、ヘッダーや編集モードの設定ができない*/
        //MARK: memo: シンプルなバインド方法
//        output.folders.bind(to: folderListTableView.rx.items(cellIdentifier: "FolderCell", cellType: FolderCell.self)){ _, element, cell in
//
//           cell.titleLabel.text = element.title
//        }.disposed(by: disposeBag)
        
        //output.folders.bind(to: provider.items)
        
        
        output.folders.subscribe(onNext: {[weak self] items in
            self?.provider.items = items
            self?.folderListTableView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    func inject(viewModel: FolderListViewModel){
        self.viewModel = viewModel
    }
}


extension FolderListViewController: UITableViewDelegate {
    
}

