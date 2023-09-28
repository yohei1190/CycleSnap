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
    @Persisted var photos: List<Photo> = .init()
}

extension Category {
    static let sampleCategory1 = Category(value: ["name": "Foliage plant", "orderIndex": 1])
    static let sampleCategory2 = Category(value: ["name": "Cooking", "orderIndex": 2])
    static let sampleCategory3 = Category(value: ["name": "Children height", "orderIndex": 3])
}
