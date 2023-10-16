//
//  PhotoListViewModel.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/16.
//

import Foundation
import RealmSwift

class PhotoListViewModel: ObservableObject {
    @Published var photoList: [Photo] = []
    private let realm: Realm
    let category: Category

    init(category: Category, realm: Realm = try! Realm()) {
        self.realm = realm
        self.category = category
        getAll()
    }

    private func getAll() {
        let isLatest = category.isLatestFirst
        let results = category.photos.sorted(by: \.captureDate, ascending: !isLatest)
        photoList = Array(results)
    }

//    func add(name: String) {
//        let categoryToAdd = Category()
//        categoryToAdd.name = name
//
//        var assignedOrderIndex = 0
//        if let categoryWithMaxOrderIndex = categoryList.max(by: { $0.orderIndex < $1.orderIndex }) {
//            assignedOrderIndex = categoryWithMaxOrderIndex.orderIndex + 1
//        }
//        categoryToAdd.orderIndex = assignedOrderIndex
//
//        do {
//            try realm.write {
//                realm.add(categoryToAdd)
//            }
//            getAll()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func update(_ category: Category, name: String) {
//        do {
//            try realm.write {
//                category.name = name
//            }
//            getAll()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func move(from sourceIndices: IndexSet, to destinationIndex: Int) {
//        var revisedCategoryList = categoryList
//        revisedCategoryList.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
//
//        do {
//            try realm.write {
//                for (index, revisedCategory) in revisedCategoryList.enumerated() {
//                    let categoryToMove = realm.object(ofType: Category.self, forPrimaryKey: revisedCategory._id)!
//                    categoryToMove.orderIndex = index
//                }
//            }
//            getAll()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }

    func delete(_ photo: Photo) {
        do {
            let photoPath = photo.path

            try realm.write {
                realm.delete(photo)
            }

            // NOTE: Documentsディレクトリから画像ファイルを削除
            try DocumentsFileHelper.remove(at: photoPath)

            getAll()
        } catch {
            print(error.localizedDescription)
        }
    }
}
