//
//  FriendViewModel.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2023/01/12.
//

import Foundation
import RxSwift

class FriendViewModel {
    let disposeBag = DisposeBag()
    var allFriends: Observable<[Friend]>
    var friends = BehaviorSubject<[Friend]>(value: [])
    
    // INPUT
    let fetchFriends: AnyObserver<Void>
    
    // OUTPUT
    let activated: Observable<Bool>
    
    init(domain: FriendFetchable = FriendStore()) {
        let fetching = PublishSubject<Void>()
        
        let friends = BehaviorSubject<[Friend]>(value: [])
        let activating = BehaviorSubject<Bool>(value: false)
        let error = PublishSubject<Error>()
        
        // INPUT
        fetchFriends = fetching.asObserver()
        
        fetching
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchFriends)
                .do(onNext: { _ in activating.onNext(false)})
                .do(onError: { err in error.onNext(err)})
                    .subscribe(onNext: friends.onNext)
                    .disposed(by: disposeBag)
    }
    
}
