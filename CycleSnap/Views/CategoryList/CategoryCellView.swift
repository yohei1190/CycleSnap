//
//  CategoryCellView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/27.
//

import SwiftUI

struct CategoryCellView: View {
    let category: Category
    let onEdit: (Category) -> Void
    let onDelete: (Category) -> Void

    var body: some View {
        HStack(spacing: 12) {
            if let latestPhoto = category.photos.last,
               let image = DocumentsFileHelper.loadUIImage(at: latestPhoto.path)
            {
                // 画像ありの場合
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                // 画像なしの場合
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .overlay {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(category.name)
                    .lineLimit(2)
                    .font(.title3)
                HStack(spacing: 0) {
                    Text(category.createdAt, style: .date)
                    Text("~")
                }
                .font(.footnote)
                .opacity(0.6)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
        .contextMenu {
            Button(action: { onEdit(category) }) {
                HStack {
                    Label("カテゴリー名を編集", systemImage: "square.and.pencil")
                }
            }
            Button(role: .destructive, action: { onDelete(category) }) {
                HStack {
                    Label("カテゴリーを削除", systemImage: "trash")
                }
            }
        }
    }
}

#if DEBUG
    struct CategoryCellView_Previews: PreviewProvider {
        static var previews: some View {
            CategoryCellView(
                category: PreviewData.category,
                onEdit: { _ in },
                onDelete: { _ in }
            )
        }
    }
#endif
