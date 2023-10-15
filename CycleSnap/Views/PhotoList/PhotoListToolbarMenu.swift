//
//  PhotoListToolbarMenu.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import RealmSwift
import SwiftUI

struct PhotoListToolbarMenu: View {
    enum SortOrder {
        case latest
        case oldest
    }

    let category: Category
    @Binding var isLatest: Bool
    @Binding var isPresentingAlert: Bool

    private func sortPhotos(by order: SortOrder) {
        do {
            let realm = try Realm()
            let editingCategory = realm.object(ofType: Category.self, forPrimaryKey: category._id)!
            try realm.write {
                editingCategory.isLatestFirst = order == .latest ? true : false
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
                    sortPhotos(by: .oldest)
                } label: {
                    Text("OldestFirst")
                    if !isLatest {
                        Image(systemName: "checkmark")
                    }
                }
                Button {
                    sortPhotos(by: .latest)
                } label: {
                    Text("NewestFirst")
                    if isLatest {
                        Image(systemName: "checkmark")
                    }
                }
            } label: {
                Label("SortOrder", systemImage: "arrow.up.arrow.down")
            }

            Button {
                withAnimation {
                    isPresentingAlert = true
                }
            } label: {
                HStack {
                    Label("EditCategoryName", systemImage: "square.and.pencil")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title2)
        }
    }
}

struct PhotoListToolbarMenuToolbarMenu_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListToolbarMenu(
            category: Realm.previewRealm.objects(Category.self).first!,
            isLatest: .constant(false),
            isPresentingAlert: .constant(false)
        )
    }
}
