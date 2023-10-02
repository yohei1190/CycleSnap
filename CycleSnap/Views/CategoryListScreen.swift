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
    @State private var isPresentingAlert = false
    @State private var isPresentingConfirmationDialog = false

    private func move(fromOffsets: IndexSet, toOffset: Int) {
        var revisedCategoryList: [Category] = categoryList.map { $0 }
        revisedCategoryList.move(fromOffsets: fromOffsets, toOffset: toOffset)

        do {
            let realm = try Realm()
            try realm.write {
                for (index, revisedCategory) in revisedCategoryList.enumerated() {
                    let category = realm.objects(Category.self).filter("_id == %@", revisedCategory._id).first!
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
                let categoryObject = realm.objects(Category.self).where { $0._id == deletingCategory._id }.first!
                realm.delete(categoryObject.photos)
                realm.delete(categoryObject)

                // NOTE: Documentsディレクトリから画像ファイルを削除
                for photo in deletingCategory.photos {
                    let imageURL = FileHelper.getFileURL(path: photo.path)
                    try FileManager.default.removeItem(at: imageURL)
                }
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
                            CategoryDetailScreen(category: category)
                        } label: {
                            CategoryCellView(category: category)
                                .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                        }
                    }
                    .onDelete { indexSet in
                        deletingCategory = categoryList[indexSet.first!]
                        isPresentingConfirmationDialog = true
                    }
                    .onMove(perform: move)
                }
                .listStyle(.plain)

                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            isPresentingAlert = true
                        }
                    } label: {
                        Label("Add Category", systemImage: "plus.circle.fill")
                    }
                }
                .padding(.top, 8)
            }
            .padding()
            .navigationTitle("Categories")
            .toolbar {
                if !categoryList.isEmpty && !isPresentingAlert {
                    EditButton()
                }
            }
            .overlay {
                if categoryList.isEmpty {
                    VStack(spacing: 12) {
                        Text("Empty Category")
                            .font(.title)
                            .bold()
                        Text("Tap the button in the bottom right to add your first category.")
                            .font(.title3)
                            .opacity(0.6)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .overlay {
                CategoryNameAlert(isPresenting: $isPresentingAlert, existingCategory: nil)
            }
            .alert("Do you want to delete \"\(deletingCategory?.name ?? "")\"?", isPresented: $isPresentingConfirmationDialog) {
                Button("Delete", role: .destructive) {
                    delete()
                    deletingCategory = nil
                }
            } message: {
                Text("This action will delete all photos in this category.")
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
