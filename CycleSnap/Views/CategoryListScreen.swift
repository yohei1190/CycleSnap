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

    @State private var categoryName = ""
    @State private var isPresentingAlert = false
    @State private var indicesToDelete: IndexSet?
    @State private var isPresentingConfirmationDialog = false

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

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(categoryList) { category in
                        NavigationLink {
                            CategoryDetailScreen()
                        } label: {
                            CategoryCellView(category: category)
                                .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                        }
                    }
                    .onDelete { indexSet in
                        indicesToDelete = indexSet
                        isPresentingConfirmationDialog = true
                    }
                    .onMove(perform: move)
                }
                .listStyle(.plain)

                HStack {
                    Spacer()
                    Button {
                        isPresentingAlert = true
                    } label: {
                        Label("Add Category", systemImage: "plus.circle.fill")
                    }
                }
                .padding(.top, 8)
            }
            .padding()
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
            .navigationTitle("Categories")
            .toolbar {
                if !categoryList.isEmpty {
                    EditButton()
                }
            }
            .alert("New Category", isPresented: $isPresentingAlert) {
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
            .alert("Do you want to delete the category?", isPresented: $isPresentingConfirmationDialog) {
                Button("Delete", role: .destructive) {
                    if let indicesToDelete {
                        $categoryList.remove(atOffsets: indicesToDelete)
                    }
                    indicesToDelete = nil
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
    }
}
