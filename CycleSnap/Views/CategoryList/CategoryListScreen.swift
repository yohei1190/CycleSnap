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
    @State private var isPresentingCategoryNameAlert = false
    @State private var isPresentingCategoryDeletingAlert = false

    init(categoryListVM: CategoryListViewModel = CategoryListViewModel()) {
        _categoryListVM = StateObject(wrappedValue: categoryListVM)
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(categoryListVM.categoryList) { category in
                        NavigationLink {
                            PhotoListScreen(category: category)
                        } label: {
                            CategoryCellView(category: category)
                                .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                                .contextMenu {
                                    Button {
                                        withAnimation {
                                            selectedCategory = category
                                            isPresentingCategoryNameAlert = true
                                        }
                                    } label: {
                                        HStack {
                                            Label("EditCategoryName", systemImage: "square.and.pencil")
                                        }
                                    }
                                    Button(role: .destructive) {
                                        withAnimation {
                                            selectedCategory = category
                                            isPresentingCategoryDeletingAlert = true
                                        }
                                    } label: {
                                        HStack {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                        }
                    }
                    .onDelete { indexSet in
                        selectedCategory = categoryListVM.categoryList[indexSet.first!]
                        isPresentingCategoryDeletingAlert = true
                    }
                    .onMove(perform: categoryListVM.move)
                }
                .listStyle(.plain)

                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            selectedCategory = nil
                            isPresentingCategoryNameAlert = true
                        }
                    } label: {
                        Label("AddCategory", systemImage: "plus.circle.fill")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding(.trailing)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Categories")
            .toolbar {
                if !categoryListVM.categoryList.isEmpty && !isPresentingCategoryNameAlert {
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
            .overlay {
                CategoryNameAlert(
                    isPresenting: $isPresentingCategoryNameAlert,
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
