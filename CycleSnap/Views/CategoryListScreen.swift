//
//  CategoryListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/27.
//

import RealmSwift
import SwiftUI

struct CategoryListScreen: View {
    @ObservedResults(Category.self, sortDescriptor: SortDescriptor(keyPath: "orderIndex", ascending: false)) var categoryList

    @State private var isPresentingCategoryAdditionalAlert = false
    @State private var categoryName = ""

    private var trimmedCategoryName: String {
        categoryName.trimmingCharacters(in: .whitespaces)
    }

    private func save() {
        let newCategory = Category()

        newCategory.name = trimmedCategoryName

        var maxOrderIndex = -1
        if !categoryList.isEmpty {
            maxOrderIndex = categoryList.max(of: \.orderIndex)!
        }
        newCategory.orderIndex = maxOrderIndex + 1

        $categoryList.append(newCategory)
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(categoryList) { category in
                        CategoryCellView(category: category)
                            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                    }
                    .onDelete(perform: $categoryList.remove)
                    .onMove(perform: { _, _ in })
                }
                .listStyle(.plain)

                HStack {
                    Spacer()
                    Button {
                        isPresentingCategoryAdditionalAlert = true
                    } label: {
                        Label("Add Category", systemImage: "plus.circle.fill")
                    }
                }
                .padding(.top, 8)
            }
            .padding()
            .navigationTitle("Categories")
            .toolbar {
                EditButton()
            }
            .alert("New Category", isPresented: $isPresentingCategoryAdditionalAlert) {
                TextField("category name", text: $categoryName)
                Button("Cancel", role: .cancel) {
                    categoryName = ""
                }
                Button("Save") {
                    save()
                    categoryName = ""
                }
                .disabled(!trimmedCategoryName.isEmpty)
            } message: {
                Text("Please enter the name of this category")
            }
        }
    }
}

struct CategoryListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListScreen()
    }
}
