//
//  CategoryNameAlert.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/01.
//

import RealmSwift
import SwiftUI

struct CategoryNameAlert: View {
    @ObservedResults(Category.self, sortDescriptor: SortDescriptor(keyPath: "orderIndex", ascending: true)) var categoryList

    @Binding var isPresenting: Bool
    @State private var editingCategoryName = ""
    @FocusState private var isFocus: Bool

    let existingCategory: Category?

    private func saveOrUpdate() {
        let trimmedCategoryName = editingCategoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedCategoryName.isEmpty else {
            return
        }

        if let existingCategory {
            update(categoryName: trimmedCategoryName, category: existingCategory)
        } else {
            save(categoryName: trimmedCategoryName)
        }
    }

    private func update(categoryName: String, category: Category) {
        do {
            let realm = try Realm()
            let updatingCategory = realm.object(ofType: Category.self, forPrimaryKey: category._id)!
            try realm.write {
                updatingCategory.name = categoryName
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func save(categoryName: String) {
        let newCategory = Category()

        newCategory.name = categoryName

        var maxOrderIndex = -1
        if !categoryList.isEmpty {
            maxOrderIndex = categoryList.max(of: \.orderIndex)!
        }
        newCategory.orderIndex = maxOrderIndex + 1

        $categoryList.append(newCategory)
    }

    var body: some View {
        if isPresenting {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {}

                VStack(spacing: 32) {
                    Text(existingCategory != nil ? "Rename Category" : "New Category")
                        .font(.title3)
                        .bold()

                    TextField("Category Name", text: $editingCategoryName)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocus)
                        .overlay(alignment: .trailing) {
                            Button {
                                editingCategoryName = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .padding(12)
                                    .foregroundColor(.gray)
                            }
                        }

                    HStack {
                        Button {
                            withAnimation {
                                isPresenting = false
                            }
                        } label: {
                            Text("Cancel")
                                .padding(.vertical, 4)
                                .padding(.horizontal, 20)
                        }
                        .buttonStyle(.bordered)

                        Button {
                            saveOrUpdate()
                            withAnimation {
                                isPresenting = false
                            }
                        } label: {
                            Text("Save")
                                .padding(.vertical, 4)
                                .padding(.horizontal, 20)
                        }
                        .disabled(editingCategoryName.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(20)
                .background(.ultraThickMaterial)
                .cornerRadius(24)
                .frame(width: 300)
            }
            .onAppear {
                editingCategoryName = ""
                if let existingCategory {
                    editingCategoryName = existingCategory.name
                }
                isFocus = true
            }
        }
    }
}

struct CategoryNameAlert_Previews: PreviewProvider {
    static var previews: some View {
        CategoryNameAlert(isPresenting: .constant(true), existingCategory: nil)
    }
}
