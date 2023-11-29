//
//  PhotoListViewModel.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/16.
//

import Foundation
import RealmSwift

final class PhotoListViewModel: ObservableObject {
    @Published var photoList: [Photo] = []

    let category: Category
    private let realm: Realm = try! Realm()
    private var notificationTokens: [NotificationToken] = []

    init(category: Category) {
        self.category = category
        getAll()
        setupNotifications()
    }

    private func setupNotifications() {
        let photosToken = category.photos.observe { [weak self] (changes: RealmCollectionChange) in
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
        photoList = Array(results)
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

    func delete(_ photo: Photo) {
        do {
            photoList = photoList.filter { $0._id != photo._id }

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
