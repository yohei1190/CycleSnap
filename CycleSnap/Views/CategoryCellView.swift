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
            // 画像なしの場合
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.gray.opacity(0.2))
//                .frame(width: 140, height: 140)
//                .overlay {
//                    Image(systemName: "photo.on.rectangle")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(.gray)
//                }

            // 画像ありの場合
            Image("sample")
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 12) {
                Text(category.name)
                    .lineLimit(2)
                    .font(.title3)
                Text("2020/01/01 ~ 2023/12/31")
                    .font(.footnote)
                    .opacity(0.6)
            }
        }
    }
}

struct CategoryCellView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCellView(category: Category.sampleCategory1)
            .padding()
    }
}
