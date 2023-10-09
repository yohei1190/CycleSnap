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

    let firstPhoto: Photo
    let lastPhoto: Photo

    private func setUIImages(_ firstPhoto: Photo, _ lastPhoto: Photo) -> [UIImage] {
        [firstPhoto, lastPhoto].compactMap { DocumentsFileHelper.loadUIImage(at: $0.path) }
    }

    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    ForEach(comparisonUIImages.indexed(), id: \.element) { index, uiImage in
                        Image(uiImage: uiImage)
                            .resizeFourThreeAspectRatio()
                            .opacity(index == 0 ? 1 : value)
                    }
                }

                VStack(spacing: 24) {
                    Slider(value: $value, in: 0 ... 1, step: 0.1)
                        .tint(.white)
                    HStack(spacing: 60) {
                        BackwardAndForwardButton(
                            action: { value = 0 },
                            symbolName: "chevron.backward.2"
                        )
                        BackwardAndForwardButton(
                            action: { value = 1 },
                            symbolName: "chevron.forward.2"
                        )
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            comparisonUIImages = setUIImages(firstPhoto, lastPhoto)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ComparisonScreenTitle")
                    .foregroundColor(.white)
            }
        }
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
