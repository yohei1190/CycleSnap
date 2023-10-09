//
//  CategoryListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/27.
//

import RealmSwift
import SwiftUI

struct CategoryListScreen: View {
    @ObservedResults(Category.self, sortDescriptor: SortDescriptor(keyPath: "orderIndex", ascending: true)) var categoryList

    @State private var deletingCategory: Category?
    @State private var isPresentingCategoryNameAlert = false
    @State private var isPresentingCategoryDeletingAlert = false

    private func move(from sourceIndices: IndexSet, to destinationIndex: Int) {
        var revisedCategoryList: [Category] = categoryList.map { $0 }
        revisedCategoryList.move(fromOffsets: sourceIndices, toOffset: destinationIndex)

        do {
            let realm = try Realm()
            try realm.write {
                for (index, revisedCategory) in revisedCategoryList.enumerated() {
                    let category = realm.object(ofType: Category.self, forPrimaryKey: revisedCategory._id)!
                    category.orderIndex = index
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func delete() {
        guard let deletingCategory else { return }

        do {
            let realm = try Realm()
            try realm.write {
                // NOTE: RealmDBからオブジェクトを削除
                let categoryObject = realm.object(ofType: Category.self, forPrimaryKey: deletingCategory._id)!
                realm.delete(categoryObject.photos)
                realm.delete(categoryObject)

                // NOTE: Documentsディレクトリの画像フォルダを削除
                try DocumentsFileHelper.remove(at: "photos/" + deletingCategory._id.stringValue)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(categoryList) { category in
                        NavigationLink {
                            PhotoListScreen(category: category)
                        } label: {
                            CategoryCellView(category: category)
                                .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                        }
                    }
                    .onDelete { indexSet in
                        deletingCategory = categoryList[indexSet.first!]
                        isPresentingCategoryDeletingAlert = true
                    }
                    .onMove(perform: move)
                }
                .listStyle(.plain)

                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            isPresentingCategoryNameAlert = true
                        }
                    } label: {
                        Label("AddCategory", systemImage: "plus.circle.fill")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding()
            }
            .navigationTitle("Categories")
            .toolbar {
                if !categoryList.isEmpty && !isPresentingCategoryNameAlert {
                    EditButton()
                }
            }
            .overlay {
                if categoryList.isEmpty {
                    VStack(spacing: 12) {
                        Text("EmptyCategory")
                            .font(.title)
                            .bold()
                        Text("EmptyCategoryMessage")
                            .font(.title3)
                            .opacity(0.6)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .overlay {
                CategoryNameAlert(isPresenting: $isPresentingCategoryNameAlert, existingCategory: nil)
            }
            .alert("CategoryDeletingAlertTitle \(deletingCategory?.name ?? "")", isPresented: $isPresentingCategoryDeletingAlert) {
                Button("DeleteCategory", role: .destructive) {
                    delete()
                    deletingCategory = nil
                }
            } message: {
                Text("CategoryDeletingAlertMessage")
            }
        }
    }
}

struct CategoryListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListScreen()
            .environment(\.realm, Realm.previewRealm)
    }
}
