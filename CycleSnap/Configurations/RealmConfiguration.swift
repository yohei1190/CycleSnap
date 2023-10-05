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
        let config = Realm.Configuration(schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }
}

extension Realm {
    static var previewRealm: Realm {
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            let realm = try Realm(configuration: config)

            let categoryList = realm.objects(Category.self)
            if categoryList.isEmpty {
                try realm.write {
                    for i in 0 ... 2 {
                        // Creating sample category
                        let category = Category()
                        category.name = "Sample Category \(i)"
                        category.orderIndex = i
                        category.isLatestFirst = true

                        for j in 1 ... 5 {
                            // Creating sample photo
                            let photo = Photo()
                            photo.path = "photos/sample\(j).jpg"
                            photo.captureDate = Calendar.current.date(byAdding: .day, value: j, to: Date())!
                            category.photos.append(photo)
                        }

                        realm.add(category)
                    }
                }
            }
            return realm
        } catch {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}
