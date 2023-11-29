//
//  RealmConfiguration.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import Foundation
import RealmSwift

final class RealmConfiguration {
    init() {
        updateSchema()
    }

    private func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 4) { migration, oldSchemaVersion in
            if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: Category.className()) { _, newObject in
                    newObject?["createdAt"] = Date()
                }
                migration.enumerateObjects(ofType: Photo.className()) { _, newObject in
                    newObject?["captureDate"] = Date()
                }
            }
        }

        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }
}
