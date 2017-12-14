//
//  RepositoryNetworkModel.swift
//  UserTracker
//
//  Created by Carlos Cortés Sánchez on 14/12/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

struct RepositoryNetworkModel {
    
    lazy var rx_respositories: Driver<[Repository]> = self.fetchRepositories()
    private var repositoryName: Observable<String>
    
    init(withNameObservable nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
    }
    
    private func fetchRepositories() -> Driver<[Repository]> {
        return repositoryName
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { text in
                return RxAlamofire
                    .requestJSON(.get, "https://api.github.com/users/\(text)/repos")
                    .debug().catchError { error in
                        return Observable.never()
                }
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response,json) -> [Repository] in
                if let repos = Mapper<Repository>().mapArray(JSONObject: json) {
                    return repos
                } else {
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
