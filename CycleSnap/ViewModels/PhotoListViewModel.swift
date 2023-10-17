//
//  PhotoListViewModel.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/16.
//

import Foundation
import RealmSwift
import SwiftUI

class PhotoListViewModel: ObservableObject {
    @Published var photoList: [Photo] = []

    private let realm: Realm
    let category: Category
    private var notificationTokens: [NotificationToken] = []

    init(category: Category, realm: Realm = try! Realm()) {
        self.realm = realm
        self.category = category
        getAll()
        setupNotifications()
    }

    private func setupNotifications() {
        let photosToken = category.photos.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .update:
                self?.getAll()
            case let .error(error):
                print(error.localizedDescription)
            default:
                break
            }
        }

        let categoryToken = category.observe { [weak self] (changes: ObjectChange) in
            switch changes {
            case .change:
                self?.getAll()
            case let .error(error):
                print(error.localizedDescription)
            default:
                break
            }
        }

        notificationTokens = [photosToken, categoryToken]
    }

    private func getAll() {
        let isLatest = category.isLatestFirst
        let results = category.photos.sorted(by: \.captureDate, ascending: !isLatest)
//        withAnimation {
        photoList = Array(results)
//        }
    }

    func sort(by order: SortOrder) {
        do {
            try realm.write {
                category.isLatestFirst = order == .latest
            }
        } catch {
            print(error.localizedDescription)
        }
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
        } catch {
            print(error.localizedDescription)
        }
    }

    deinit {
        notificationTokens.forEach { $0.invalidate() }
    }
}
