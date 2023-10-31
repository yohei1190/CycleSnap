//
//  PreviewData.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/27.
//

import Foundation
import RealmSwift

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

enum PreviewData {
    static let previewRealm = Realm.previewRealm

    static let categoryList: Results<Category> = previewRealm.objects(Category.self)
    static let category: Category = categoryList.first!

    static let photoList: List<Photo> = categoryList.first!.photos
    static let photo: Photo = photoList.first!
}
