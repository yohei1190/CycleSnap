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
    private var realm: Realm
    private var categoryResults: Results<Category>

    init(realm: Realm = try! Realm()) {
        self.realm = realm
        categoryResults = realm.objects(Category.self).sorted(byKeyPath: "orderIndex")
        categoryList = Array(categoryResults)
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
            categoryList = Array(categoryResults)
        } catch {
            print(error.localizedDescription)
        }
    }

    func update(_ category: Category, name: String) {
        do {
            let categoryToUpdate = realm.object(ofType: Category.self, forPrimaryKey: category._id)!
            try realm.write {
                categoryToUpdate.name = name
            }
            categoryList = Array(categoryResults)
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
            categoryList = Array(categoryResults)
        } catch {
            print(error.localizedDescription)
        }
    }

    func delete(_ category: Category) {
        do {
            try realm.write {
                let categoryToDelete = realm.object(ofType: Category.self, forPrimaryKey: category._id)!
                realm.delete(categoryToDelete.photos)
                realm.delete(categoryToDelete)
            }

            // NOTE: Documentsディレクトリの画像フォルダを削除
            try DocumentsFileHelper.remove(at: "photos/" + category._id.stringValue)

            categoryList = Array(categoryResults)

        } catch {
            print(error.localizedDescription)
        }
    }
}
