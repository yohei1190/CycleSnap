//
//  PhotoCellView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/16.
//

import RealmSwift
import SwiftUI

struct PhotoCellView: View {
    let photo: Photo
    let onDelete: (Photo) -> Void

    @State private var loadedImage: UIImage?
    private let screenWidth = UIScreen.main.bounds.size.width

    private func loadUIImageAsync(at relativePath: String) async -> UIImage? {
        DocumentsFileHelper.loadUIImage(at: relativePath)
    }

    var body: some View {
        Group {
            if let loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth / 3, height: screenWidth / 3)
                    .clipped()
                    .overlay(alignment: .bottomTrailing) {
                        Text(photo.captureDate, style: .date)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.4))
                    }
                    .contextMenu {
                        Button(role: .destructive, action: { onDelete(photo) }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: screenWidth / 3, height: screenWidth / 3)
                    ProgressView()
                }
            }
        }
        .task {
            loadedImage = await loadUIImageAsync(at: photo.path)
        }
    }
}

struct PhotoCellView_Previews: PreviewProvider {
    static let photo = Realm.previewRealm.objects(Category.self).first!.photos.first!
    static var previews: some View {
        PhotoCellView(photo: photo, onDelete: { _ in })
    }
}
