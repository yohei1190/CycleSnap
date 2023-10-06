//
//  CategoryCellView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/27.
//

import RealmSwift
import SwiftUI

struct CategoryCellView: View {
    @ObservedRealmObject var category: Category

    var body: some View {
        HStack(spacing: 12) {
            if let latestPhoto = category.photos.last,
               let image = FileHelper.loadImage(latestPhoto.path)
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
    }
}

struct CategoryCellView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCellView(category: Realm.previewRealm.objects(Category.self).first!)
    }
}
