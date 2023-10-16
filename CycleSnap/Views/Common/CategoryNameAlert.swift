//
//  CategoryNameAlert.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/01.
//

import RealmSwift
import SwiftUI

struct CategoryNameAlert: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var editingCategoryName = ""
    @FocusState private var isFocus: Bool

    @Binding var isPresenting: Bool
    let updatingCategory: Category?
    let add: (String) -> Void
    let update: (Category, String) -> Void

    private var trimmedCategoryName: String {
        editingCategoryName.trimmingCharacters(in: .whitespaces)
    }

    private func saveOrUpdate() {
        guard !trimmedCategoryName.isEmpty else {
            return
        }

        if let updatingCategory {
            update(updatingCategory, trimmedCategoryName)
        } else {
            add(trimmedCategoryName)
        }
    }

    var body: some View {
        if isPresenting {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {}

                VStack {
                    VStack(spacing: 28) {
                        Text(updatingCategory != nil ? "RenameCategory" : "NewCategory")
                            .font(.title3)
                            .bold()

                        TextField("CategoryName", text: $editingCategoryName)
                            .frame(minHeight: 44)
                            .padding(.leading, 8)
                            .padding(.trailing, 36)
                            .background(RoundedRectangle(cornerRadius: 12).fill(colorScheme == .dark ? .black.opacity(0.8) : .white))
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
                    }

                    Divider()

                    HStack(spacing: 20) {
                        Button {
                            withAnimation {
                                isPresenting = false
                            }
                        } label: {
                            Text("Cancel")
                                .bold()
                                .frame(minWidth: 80, minHeight: 44)
                                .padding(.horizontal)
                        }

                        Button {
                            saveOrUpdate()
                            withAnimation {
                                isPresenting = false
                            }
                        } label: {
                            Text("Save")
                                .frame(minWidth: 80, minHeight: 44)
                                .padding(.horizontal)
                        }
                        .disabled(editingCategoryName.isEmpty)
                    }
                }
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(24)
                .frame(width: 300)
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
}

struct CategoryNameAlert_Previews: PreviewProvider {
    static var previews: some View {
        CategoryNameAlert(
            isPresenting: .constant(true),
            updatingCategory: nil,
            add: { _ in },
            update: { _, _ in }
        )
    }
}
