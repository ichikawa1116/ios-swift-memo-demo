//
//  MemoDetailViewController.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/11/24.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    private let leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: nil, action: nil)
    private var viewModel: MemoDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setupUI() {
        memoTextView.backgroundColor = #colorLiteral(red: 0.6815562594, green: 0.9538776137, blue: 0.9764705896, alpha: 1)
        
    }
    
    
    private func bindViewModel() {
        
        let input = MemoDetailViewModel.Input(viewWillAppear: rx.sentMessage(#selector(viewWillAppear)).take(1).mapToVoid(), tapBackButton: leftBarButtonItem.rx.tap
            .asObservable()
            .map { self.memoTextView.text })
        
        let output = viewModel.transform(input: input)
        
        output.didGoBack.subscribe().disposed(by: disposeBag)
    }
    
    func inject(viewModel: MemoDetailViewModel){
        self.viewModel = viewModel
    }
    
    
    
}
