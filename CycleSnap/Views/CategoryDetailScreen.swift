//
//  CategoryDetailScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import RealmSwift
import SwiftUI

struct CategoryDetailScreen: View {
    @ObservedRealmObject var category: Category
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)

    private func loadImage(_ path: String) -> UIImage? {
        let documentsDirectory = URL.documentsDirectory
        let imageURL = documentsDirectory.appendingPathComponent(path)
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }

        return UIImage(data: imageData)
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(1, contentMode: .fill)
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .font(.title2)
                                .bold()
                        }

                    ForEach(category.photos) { photo in
                        if let uiImage = loadImage(photo.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .overlay(alignment: .bottomTrailing) {
                                    Text(photo.captureDate, style: .date)
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .background(.black.opacity(0.4))
                                }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {} label: {
                        HStack {
                            Text("Oldest First")
                            Image(systemName: "arrow.up")
                        }
                    }
                    Button {} label: {
                        HStack {
                            Text("Newest First")
                            Image(systemName: "arrow.down")
                        }
                    }
                    Button {} label: {
                        HStack {
                            Text("Edit Category name")
                            Image(systemName: "square.and.pencil")
                        }
                    }

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
            CategoryDetailScreen(category: Category.sampleCategory1)
        }
    }
}
