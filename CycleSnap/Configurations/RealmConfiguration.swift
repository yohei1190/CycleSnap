//
//  RealmConfiguration.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import Foundation
import RealmSwift

class RealmConfiguration {
    init() {
        updateSchema()
    }

    func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }
}
