//
//  CategoryListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/27.
//

import SwiftUI

struct CategoryListScreen: View {
    @State private var isPresentingCategoryAdditionalAlert = false
    @State private var categoryName = ""

    private var trimmedCategoryName: String {
        categoryName.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0 ... 5, id: \.self) { _ in
                        CategoryCellView()
                            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                    }
                    .onDelete(perform: { _ in })
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
                Button("Cancel", role: .cancel, action: {})
                Button("Save") {
                    // TODO: save処理
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
