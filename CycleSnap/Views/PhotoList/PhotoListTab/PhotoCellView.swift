//
//  PhotoCellView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/16.
//

import SwiftUI

struct PhotoCellView: View {
    let photo: Photo
    let onTap: (Photo) -> Void
    let onDelete: (Photo) -> Void

    @State private var loadedImage: UIImage?
    private let screenWidth = UIScreen.main.bounds.size.width

    private func loadUIImageAsync(at relativePath: String) async -> UIImage? {
        DocumentsFileHelper.loadUIImage(at: relativePath)
    }

    var body: some View {
        Button(action: { onTap(photo) }) {
            AsyncImage(url: DocumentsFileHelper.getURL(at: photo.path)) { image in
                image
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
                            Label("写真を削除", systemImage: "trash")
                        }
                    }
            } placeholder: {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: screenWidth / 3, height: screenWidth / 3)
                    ProgressView()
                }
            }
        }
    }
}

#if DEBUG
    struct PhotoCellView_Previews: PreviewProvider {
        static var previews: some View {
            PhotoCellView(photo: PreviewData.photo, onTap: { _ in }, onDelete: { _ in })
        }
    }
#endif
