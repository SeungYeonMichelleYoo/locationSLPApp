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
    
    
}
