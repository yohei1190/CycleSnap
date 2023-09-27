//
//  CategoryListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/27.
//

import SwiftUI

struct CategoryListScreen: View {
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
                        // action
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
        }
    }
}

struct CategoryListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListScreen()
    }
}
