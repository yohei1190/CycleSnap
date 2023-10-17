//
//  ComparisonScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/08.
//

import Algorithms
import RealmSwift
import SwiftUI

struct ComparisonScreen: View {
    @State private var value: CGFloat = 0
    @State private var comparisonUIImages: [UIImage] = []

    init(firstPhoto: Photo, lastPhoto: Photo) {
        let uiImages = [firstPhoto, lastPhoto].compactMap { DocumentsFileHelper.loadUIImage(at: $0.path)
        }
        _comparisonUIImages = State(wrappedValue: uiImages)
    }

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                ForEach(comparisonUIImages.indexed(), id: \.element) { index, uiImage in
                    Image(uiImage: uiImage)
                        .resizeFourThreeAspectRatio()
                        .opacity(index == 0 ? 1 : value)
                }
            }

            VStack(spacing: 20) {
                Slider(value: $value, in: 0 ... 1, step: 0.1)
                    .tint(.primary)
                HStack(spacing: 60) {
                    BackwardAndForwardButton(
                        onTap: { value = 0 },
                        symbolName: "arrow.left.circle.fill"
                    )
                    BackwardAndForwardButton(
                        onTap: { value = 1 },
                        symbolName: "arrow.right.circle.fill"
                    )
                }
            }
            .padding(.horizontal, 40)
        }
        .navigationTitle("ComparisonScreenTitle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ComparisonScreen_Previews: PreviewProvider {
    static let photos = Realm.previewRealm.objects(Category.self).first!.photos

    static var previews: some View {
        NavigationStack {
            ComparisonScreen(
                firstPhoto: photos.first!,
                lastPhoto: photos.last!
            )
        }
    }
}
