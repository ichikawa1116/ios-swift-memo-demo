//
//  MemoListBuilder.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/11/23.

//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import Foundation
import UIKit

struct MemoListBuilder {
    
    static func build(folder: Folder) -> MemoListViewController {
        
        let storyboard = UIStoryboard(name: "MemoListViewController", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "MemoListViewController") as! MemoListViewController
        let router = MemoListRouterImpl(viewController)
        let viewModel = MemoListViewModel(saveMemoUseCase: SaveMemoUseCaseImpl(memoRepository: MemoRepositoryImpl( dataStore: MemoDataStoreDBImpl()), folderRepository: FolderRepositoryImpl(dataStore: FolderDBImpl())),
                                          fetchMemoUseCase: FetchMemoUseCaseImpl(repository: FolderRepositoryImpl(dataStore: FolderDBImpl())),
                                          folder: folder,
                                          router: router
                                          )
                                                                        
            
//            MemoRepositoryImpl(dataStore: MemoDataStoreDBImpl())),
//                                          fetchMemoUseCase: FetchMemoUseCaseImpl(repository: FolderRepositoryImpl(dataStore: FolderDBImpl())),
//                                          folderId: folder.folderID,
//                                          router: router )
//
        viewController.inject(viewModel: viewModel, folder: folder)
        
        return viewController
    }
}
