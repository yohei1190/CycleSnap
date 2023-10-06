//
//  Category.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import Foundation
import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var orderIndex: Int
    @Persisted var photos: List<Photo>
    @Persisted var isLatestFirst: Bool = true
    @Persisted var createdAt: Date = .init()
}
