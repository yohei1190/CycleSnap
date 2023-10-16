//
//  CategoryListViewModel.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/15.
//

import Foundation
import RealmSwift

class CategoryListViewModel: ObservableObject {
    @Published var categoryList: [Category] = []
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
        getAll()
    }

    private func getAll() {
        let results = realm.objects(Category.self).sorted(by: \.orderIndex)
        categoryList = Array(results)
    }

    func add(name: String) {
        let categoryToAdd = Category()
        categoryToAdd.name = name

        var assignedOrderIndex = 0
        if let categoryWithMaxOrderIndex = categoryList.max(by: { $0.orderIndex < $1.orderIndex }) {
            assignedOrderIndex = categoryWithMaxOrderIndex.orderIndex + 1
        }
        categoryToAdd.orderIndex = assignedOrderIndex

        do {
            try realm.write {
                realm.add(categoryToAdd)
            }
            getAll()
        } catch {
            print(error.localizedDescription)
        }
    }

    func update(_ category: Category, name: String) {
        do {
            try realm.write {
                category.name = name
            }
            getAll()
        } catch {
            print(error.localizedDescription)
        }
    }

    func move(from sourceIndices: IndexSet, to destinationIndex: Int) {
        var revisedCategoryList = categoryList
        revisedCategoryList.move(fromOffsets: sourceIndices, toOffset: destinationIndex)

        do {
            try realm.write {
                for (index, revisedCategory) in revisedCategoryList.enumerated() {
                    let categoryToMove = realm.object(ofType: Category.self, forPrimaryKey: revisedCategory._id)!
                    categoryToMove.orderIndex = index
                }
            }
            getAll()
        } catch {
            print(error.localizedDescription)
        }
    }

    func delete(_ category: Category) {
        do {
            let categoryIdString = category._id.stringValue
            try realm.write {
                realm.delete(category.photos)
                realm.delete(category)
            }
            // NOTE: Documentsディレクトリの画像フォルダを削除
            try DocumentsFileHelper.remove(at: "photos/" + categoryIdString)

            getAll()
        } catch {
            print(error.localizedDescription)
        }
    }
}
