//
//  FetchMemoUseCase.swift
//  swift-memo-demo
//
//  Created by Manami Ichikawa on 2018/12/08.
//  Copyright © 2018 Manami Ichikawa. All rights reserved.
//

import Foundation
import RxSwift

protocol FetchMemoUseCase {
    
    func fetchMemos(folderID: Int) -> Observable<[Memo]>
    
}

struct FetchMemoUseCaseImpl: FetchMemoUseCase {
    
    private var repository: FolderRepository!
    
    init(repository: FolderRepository) {
        self.repository = repository
    }
    
    func fetchMemos(folderID: Int) -> Observable<[Memo]> {
        return repository.fetchMemos(folderID: folderID)
    }
}
