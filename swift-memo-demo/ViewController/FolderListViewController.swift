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
    let textfield = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.folderListTableView.delegate = self
        //self.folderListTableView.dataSource = self
        folderListTableView.register (UINib(nibName: String(describing: FolderCell.self), bundle: nil),forCellReuseIdentifier:"FolderCell")
        
        bindViewModel()
    }
    
    func bindViewModel() {
        
        let refreshTrigger = rx.sentMessage(#selector(viewWillAppear)).take(1).mapToVoid()
        let createFolderTrigger = addFolderButton.rx.tap.asDriver()
        let input = FolderListViewModel.Input(createFolderTrigger: createFolderTrigger,
                                              refreshTrigger: refreshTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.didCreateFolder.drive(onNext:{
            print("folder is created")
        }).disposed(by: disposeBag)
        
        
        output.folders.bind(to: folderListTableView.rx.items(cellIdentifier: "FolderCell", cellType: FolderCell.self)){ _, element, cell in

           cell.titleLabel.text = element.title
        }.disposed(by: disposeBag)
        
    }
    
    func inject(viewModel: FolderListViewModel){
        self.viewModel = viewModel
    }
}


extension FolderListViewController: UITableViewDelegate {
    
}

