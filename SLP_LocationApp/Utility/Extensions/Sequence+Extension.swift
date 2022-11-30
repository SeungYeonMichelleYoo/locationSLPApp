//
//  Hashable+Extension.swift
//  SLP_LocationApp
//
//  Created by SeungYeon Yoo on 2022/11/30.
//

import Foundation
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
