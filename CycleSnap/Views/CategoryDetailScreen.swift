//
//  CategoryDetailScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import SwiftUI

struct CategoryDetailScreen: View {
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .font(.title2)
                                .bold()
                        }

                    ForEach(0 ... 10, id: \.self) { _ in
                        Image("sample")
                            .resizable()
                            .scaledToFill()
                            .overlay(alignment: .bottomTrailing) {
                                Text("2023/09/28")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .background(.black.opacity(0.4))
                            }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // action
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                }
            }
        }
    }
}

struct CategoryDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CategoryDetailScreen()
        }
    }
}
