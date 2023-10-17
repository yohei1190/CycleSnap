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
    private var notificationToken: NotificationToken?

    init(realm: Realm = try! Realm()) {
        self.realm = realm
        getAll()
        setupNotifications()
    }

    private func setupNotifications() {
        notificationToken = realm.objects(Category.self).observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case let .update(_, deletions, _, _):
                if deletions.isEmpty {
                    self?.getAll()
                }
            case let .error(error):
                print(error.localizedDescription)
            default:
                break
            }
        }
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
        } catch {
            print(error.localizedDescription)
        }
    }

    func update(_ category: Category, name: String) {
        do {
            try realm.write {
                category.name = name
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func move(from sourceIndices: IndexSet, to destinationIndex: Int) {
        do {
            var revisedCategoryList = categoryList
            revisedCategoryList.move(fromOffsets: sourceIndices, toOffset: destinationIndex)

            try realm.write {
                for (index, revisedCategory) in revisedCategoryList.enumerated() {
                    let categoryToMove = realm.object(ofType: Category.self, forPrimaryKey: revisedCategory._id)!
                    categoryToMove.orderIndex = index
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func delete(_ category: Category) {
        do {
            // Viewが削除したcategoryを使用しないように、事前にcategoryListを更新しておく
            categoryList = categoryList.filter { $0._id != category._id }
            let categoryIdString = category._id.stringValue

            try realm.write {
                realm.delete(category.photos)
                realm.delete(category)
            }
            // NOTE: Documentsディレクトリの画像フォルダを削除
            try DocumentsFileHelper.remove(at: "photos/" + categoryIdString)
        } catch {
            print(error.localizedDescription)
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
