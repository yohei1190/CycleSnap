//
//  ComparisonScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/08.
//

import RealmSwift
import SwiftUI

struct ComparisonScreen: View {
    @State private var value: CGFloat = 0

    let firstIndexedPhoto: IndexedPhoto
    let lastIndexedPhoto: IndexedPhoto

    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    ForEach([firstIndexedPhoto, lastIndexedPhoto]) { indexedPhoto in
                        if let uiImage = DocumentsFileHelper.loadUIImage(at: indexedPhoto.photo.path) {
                            Image(uiImage: uiImage)
                                .resizeFourThreeAspectRatio()
                                .opacity(indexedPhoto.id == 0 ? 1 : value)
                        }
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
                firstIndexedPhoto: IndexedPhoto(id: 0, photo: photos.first!),
                lastIndexedPhoto: IndexedPhoto(id: 1, photo: photos.last!)
            )
        }
    }
}
