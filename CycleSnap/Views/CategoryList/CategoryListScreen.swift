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

    private func handleAdd() {
        withAnimation {
            selectedCategory = nil
            isPresentingCategoryNameSheet = true
        }
    }

    private func handleEdit(category: Category) {
        withAnimation {
            selectedCategory = category
            isPresentingCategoryNameSheet = true
        }
    }

    private func handleDelete(category: Category) {
        selectedCategory = category
        isPresentingCategoryDeletingAlert = true
    }

    private func handleDelete(indexSet: IndexSet) {
        selectedCategory = categoryListVM.categoryList[indexSet.first!]
        isPresentingCategoryDeletingAlert = true
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(categoryListVM.categoryList) { category in
                        if !category.isInvalidated {
                            NavigationLink {
                                PhotoListScreen(category: category)
                            } label: {
                                CategoryCellView(category: category, onEdit: handleEdit, onDelete: handleDelete)
                            }
                        }
                    }
                    .onDelete(perform: handleDelete)
                    .onMove(perform: categoryListVM.move)
                }
                .listStyle(.plain)

                HStack {
                    Spacer()
                    Button(action: handleAdd) {
                        Label("AddCategory", systemImage: "plus.circle.fill")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding(.trailing)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Categories")
            .toolbar {
                if !categoryListVM.categoryList.isEmpty {
                    EditButton()
                }
            }
            .overlay {
                if categoryListVM.categoryList.isEmpty {
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
            .sheet(isPresented: $isPresentingCategoryNameSheet) {
                CategoryNameSheet(
                    updatingCategory: selectedCategory,
                    add: categoryListVM.add,
                    update: categoryListVM.update
                )
            }
            .alert("CategoryDeletingAlertTitle \(selectedCategory?.name ?? "")", isPresented: $isPresentingCategoryDeletingAlert) {
                Button("DeleteCategory", role: .destructive) {
                    if let selectedCategory {
                        categoryListVM.delete(selectedCategory)
                    }
                    selectedCategory = nil
                }
            } message: {
                Text("CategoryDeletingAlertMessage")
            }
        }
    }
}

struct CategoryListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListScreen(categoryListVM: CategoryListViewModel(realm: Realm.previewRealm))
    }
}
