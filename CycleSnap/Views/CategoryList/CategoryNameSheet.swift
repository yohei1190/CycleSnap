//
//  CategoryNameSheet.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/17.
//

import SwiftUI

struct CategoryNameSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editingCategoryName = ""
    @FocusState private var isFocus: Bool

    let updatingCategory: Category?
    let add: (String) -> Void
    let update: (Category, String) -> Void

    private var trimmedCategoryName: String {
        editingCategoryName.trimmingCharacters(in: .whitespaces)
    }

    private func addOrUpdate() {
        guard !trimmedCategoryName.isEmpty else { return }

        if let updatingCategory {
            update(updatingCategory, trimmedCategoryName)
        } else {
            add(trimmedCategoryName)
        }
        dismiss()
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("CategoryName", text: $editingCategoryName, onCommit: addOrUpdate)
                    .frame(minHeight: 44)
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
                    .textFieldStyle(.roundedBorder)
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .frame(minWidth: 80, minHeight: 44)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(updatingCategory != nil ? "RenameCategory" : "NewCategory")
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addOrUpdate) {
                        Text("Save")
                            .frame(minWidth: 80, minHeight: 44)
                    }
                    .disabled(trimmedCategoryName.isEmpty)
                }
            }
        }
        .onAppear {
            editingCategoryName = ""
            if let updatingCategory {
                editingCategoryName = updatingCategory.name
            }
            isFocus = true
        }
    }
}

struct CategoryNameSheet_Previews: PreviewProvider {
    static var previews: some View {
        CategoryNameSheet(
            updatingCategory: nil,
            add: { _ in },
            update: { _, _ in }
        )
    }
}
