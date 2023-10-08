//
//  Photo.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import Foundation
import RealmSwift

class Photo: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var path: String
    @Persisted var captureDate: Date = .init()
}

struct IndexedPhoto: Identifiable {
    let id: Int
    let photo: Photo
}
