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

    private var trimmedCategoryName: String {
        editingCategoryName.trimmingCharacters(in: .whitespaces)
    }

    private func saveOrUpdate() {
        guard !trimmedCategoryName.isEmpty else {
            return
        }

        if let existingCategory {
            update(existingCategory)
        } else {
            save()
        }
    }

    private func update(_ category: Category) {
        do {
            let realm = try Realm()
            let updatingCategory = realm.object(ofType: Category.self, forPrimaryKey: category._id)!
            try realm.write {
                updatingCategory.name = trimmedCategoryName
            }
        } catch {
            print(error.localizedDescription)
        }
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
        if isPresenting {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {}

                VStack(spacing: 32) {
                    Text(existingCategory != nil ? "RenameCategory" : "NewCategory")
                        .font(.title3)
                        .bold()

                    TextField("CategoryName", text: $editingCategoryName)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocus)
                        .overlay(alignment: .trailing) {
                            Button {
                                editingCategoryName = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .frame(minWidth: 44, minHeight: 44)
                                    .foregroundColor(.gray)
                            }
                        }

                    HStack(spacing: 16) {
                        Button {
                            withAnimation {
                                isPresenting = false
                            }
                        } label: {
                            Text("Cancel")
                                .frame(width: 88, height: 44)
                        }
                        .buttonStyle(.bordered)

                        Button {
                            saveOrUpdate()
                            withAnimation {
                                isPresenting = false
                            }
                        } label: {
                            Text("Save").frame(width: 88, height: 44)
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
