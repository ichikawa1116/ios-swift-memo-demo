//
//  MemoDetailBuilder.swift
//  swift-memo-demo
//
//  Created on 2018/11/24.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit

struct MemoDetailBuilder {
    static func build(folder: Folder) -> MemoDetailViewController {
        
        let storyboard = UIStoryboard(name: "MemoDetailViewController", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "MemoDetailViewController") as! MemoDetailViewController
        let router = MemoDetailRouterImpl(viewController)
        let viewModel = MemoDetailViewModel(
            useCase: SaveMemoUseCaseImpl(
                memoRepository: MemoRepositoryImpl(
                    dataStore: MemoDataStoreDBImpl()),
                folderRepository: FolderRepositoryImpl(
                    dataStore: FolderDBImpl())),
            folder: folder,
            router: router)
        
        viewController.inject(viewModel: viewModel)
        return viewController
    }
}
