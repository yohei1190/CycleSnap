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
                        category.name = "SampleCategory\(i)"
                        category.orderIndex = i
                        category.isLatestFirst = true

                        for j in 0 ... 4 {
                            // Creating sample photo
                            let photo = Photo()
                            photo.path = "photos/" + category.name + "/sample\(j).jpg"
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
