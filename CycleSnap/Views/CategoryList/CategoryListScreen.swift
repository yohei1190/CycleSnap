//
//  CategoryListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/27.
//

import RealmSwift
import SwiftUI

struct CategoryListScreen: View {
    @StateObject private var categoryListVM: CategoryListViewModel

    @State private var selectedCategory: Category?
    @State private var isPresentingCategoryNameSheet = false
    @State private var isPresentingCategoryDeletingAlert = false

    init(categoryListVM: CategoryListViewModel = CategoryListViewModel()) {
        _categoryListVM = StateObject(wrappedValue: categoryListVM)
    }

    private var categoryList: [Category] {
        categoryListVM.categoryList
    }

    private func handleAdd() {
        selectedCategory = nil
        isPresentingCategoryNameSheet = true
    }

    private func handleEdit(category: Category) {
        selectedCategory = category
        isPresentingCategoryNameSheet = true
    }

    private func handleDeleteConfirmation(category: Category) {
        selectedCategory = category
        isPresentingCategoryDeletingAlert = true
    }

    private func handleDeleteConfirmation(indexSet: IndexSet) {
        selectedCategory = categoryList[indexSet.first!]
        isPresentingCategoryDeletingAlert = true
    }

    private func handleDelete() {
        if let selectedCategory {
            categoryListVM.delete(selectedCategory)
        }
        selectedCategory = nil
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(categoryList) { category in
                        if !category.isInvalidated {
                            NavigationLink {
                                PhotoListScreen(category: category)
                            } label: {
                                CategoryCellView(
                                    category: category,
                                    onEdit: handleEdit,
                                    onDelete: handleDeleteConfirmation
                                )
                            }
                        }
                    }
                    .onDelete(perform: handleDeleteConfirmation)
                    .onMove(perform: categoryListVM.move)
                }
                .listStyle(.plain)

                HStack {
                    Spacer()
                    Button(action: handleAdd) {
                        Label("カテゴリーを追加", systemImage: "plus.circle.fill")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding(.trailing)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("カテゴリー")
            .toolbar {
                if !categoryList.isEmpty {
                    EditButton()
                        .frame(minWidth: 44, minHeight: 44)
                }
            }
            .overlay {
                if categoryList.isEmpty {
                    VStack(spacing: 12) {
                        Text("カテゴリーはありません")
                            .font(.title2)
                            .bold()
                        Text("右下のボタンから最初のカテゴリーを追加しましょう")
                            .opacity(0.6)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .sheet(isPresented: $isPresentingCategoryNameSheet) {
                CategoryNameSheet(
                    updatingCategory: selectedCategory,
                    add: categoryListVM.add,
                    update: categoryListVM.update
                )
            }
            .alert("\(selectedCategory?.name ?? "") を削除しますか？", isPresented: $isPresentingCategoryDeletingAlert) {
                Button("削除", role: .destructive, action: handleDelete)
            } message: {
                Text("この操作によりこのカテゴリーにある写真がすべて削除されます")
            }
        }
    }
}

#if DEBUG
    struct CategoryListScreen_Previews: PreviewProvider {
        static var previews: some View {
            CategoryListScreen(categoryListVM: CategoryListViewModel(realm: Realm.previewRealm))
        }
    }
#endif
