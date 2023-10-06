//
//  PhotoListToolbarMenu.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import RealmSwift
import SwiftUI

struct PhotoListToolbarMenu: View {
    let category: Category
    @Binding var isLatest: Bool
    @Binding var isPresentingAlert: Bool

    private func updatePhotoOrder(isLatestFirst: Bool) {
        do {
            let realm = try Realm()
            let editingCategory = realm.object(ofType: Category.self, forPrimaryKey: category._id)!
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

            Button {
                withAnimation {
                    isPresentingAlert = true
                }
            } label: {
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

struct PhotoListToolbarMenuToolbarMenu_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListToolbarMenu(category: Realm.previewRealm.objects(Category.self).first!, isLatest: .constant(false), isPresentingAlert: .constant(false))
    }
}
