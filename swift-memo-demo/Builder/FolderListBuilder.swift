//
//  FolderListBuilder.swift
//  swift-memo-demo
//
//  Created on 2018/11/04.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit

struct FolderListBuilder {
    
    static func build() -> FolderListViewController {
        
        let storyboard = UIStoryboard(name: "FolderListViewController", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "FolderListViewController") as! FolderListViewController
        let router = FolderListRouterImpl(viewController)
        let presenter = FolderListViewModel(service:FolderServiceImpl(dao: FolderDaoImpl()) ,router: router)
        viewController.inject(viewModel: presenter)
        
        
//        let mainVC = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        
        return viewController
    }
}

