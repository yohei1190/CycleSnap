//
//  CategoryDetailToolbarMenu.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import RealmSwift
import SwiftUI

struct CategoryDetailToolbarMenu: View {
    let category: Category
    @Binding var isLatest: Bool

    private func updatePhotoOrder(isLatestFirst: Bool) {
        do {
            let realm = try Realm()
            let editingCategory = realm.objects(Category.self).first(where: { $0._id == category._id })!
            try realm.write {
                editingCategory.isLatestFirst = isLatestFirst
            }
            withAnimation {
                isLatest = editingCategory.isLatestFirst
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    var body: some View {
        Menu {
            Menu {
                Button {
                    updatePhotoOrder(isLatestFirst: false)
                } label: {
                    Text("Oldest First")
                    if !isLatest {
                        Image(systemName: "checkmark")
                    }
                }
                Button {
                    updatePhotoOrder(isLatestFirst: true)
                } label: {
                    Text("Newest First")
                    if isLatest {
                        Image(systemName: "checkmark")
                    }
                }
            } label: {
                Text("Sort Order")
                Image(systemName: "arrow.up.arrow.down")
            }

            Button {} label: {
                HStack {
                    Text("Edit Category name")
                    Image(systemName: "square.and.pencil")
                }
            }

        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title2)
        }
    }
}

struct CategoryDetailToolbarMenu_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailToolbarMenu(category: Realm.previewRealm.objects(Category.self).first!, isLatest: .constant(false))
    }
}
