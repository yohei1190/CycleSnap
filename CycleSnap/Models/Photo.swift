//
//  Photo.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import Foundation
import RealmSwift

final class Photo: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var path: String
    @Persisted var captureDate: Date = .init()
}
