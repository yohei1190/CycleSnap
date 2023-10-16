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
    let onTap: (Photo) -> Void
    let onDelete: (Photo) -> Void

    private let screenWidth = UIScreen.main.bounds.size.width

    var body: some View {
        if let uiImage = DocumentsFileHelper.loadUIImage(at: photo.path) {
            Button(action: { onTap(photo) }) {
                Image(uiImage: uiImage)
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
            }
        }
    }
}

struct PhotoCellView_Previews: PreviewProvider {
    static let photo = Realm.previewRealm.objects(Category.self).first!.photos.first!
    static var previews: some View {
        PhotoCellView(photo: photo, onTap: { _ in }, onDelete: { _ in })
    }
}
