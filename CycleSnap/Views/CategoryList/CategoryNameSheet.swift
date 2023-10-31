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
        VStack {
            // キーボードの1文字目が予測変換対象外になるバグがあるため、NavigationStackを削除してHstackでボタンを配置
            HStack {
                Button(action: { dismiss() }) {
                    Text("キャンセル").frame(minWidth: 80, minHeight: 44)
                }
                Spacer()
                Text(updatingCategory != nil ? "カテゴリーを編集" : "新規カテゴリー").bold()
                Spacer()
                Button(action: addOrUpdate) {
                    Text("保存").frame(minWidth: 80, minHeight: 44)
                }
                .disabled(trimmedCategoryName.isEmpty)
            }

            TextField("カテゴリー名", text: $editingCategoryName, onCommit: addOrUpdate)
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
