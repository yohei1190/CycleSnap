//
//  TimeLineScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/05.
//

import RealmSwift
import SwiftUI

struct TimeLineScreen: View {
    @State private var value: CGFloat = 0
    let photoList: [Photo]
    let index: Int

    private var maxPhotoIndex: Int {
        photoImages.count - 1
    }

    private var photoImages: [UIImage] {
        var photoImages: [UIImage] = []
        for photo in photoList {
            if let uiImage = FileHelper.loadImage(photo.path) {
                photoImages.append(uiImage)
            }
        }
        return photoImages
    }

    private func calculateOpacity(for index: Int) -> Double {
        let cgFloatIndex = CGFloat(index)

        if cgFloatIndex == 0 {
            return 1
        } else {
            if value <= cgFloatIndex - 1 {
                return 0
            } else if cgFloatIndex - 1 < value && value <= cgFloatIndex {
                return Double(value - (cgFloatIndex - 1))
            } else {
                return 1
            }
        }
    }

    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    ForEach(0 ... maxPhotoIndex, id: \.self) { index in
                        Image(uiImage: photoImages[index])
                            .resizeFourThreeAspectRatio()
                            .opacity(calculateOpacity(for: index))
                    }
                }

                if maxPhotoIndex > 0 {
                    VStack(spacing: 24) {
                        Slider(value: $value, in: 0 ... CGFloat(maxPhotoIndex), step: 0.2)
                            .tint(.white)
                        HStack {
                            BackwardAndForwardButton(
                                action: { value = 0 },
                                symbolName: "chevron.backward.2"
                            )
                            Spacer()
                            BackwardAndForwardButton(
                                action: {
                                    if value < 1 {
                                        value = 0
                                    } else {
                                        if value == floor(value) {
                                            value -= 1
                                        } else {
                                            value = floor(value)
                                        }
                                    }
                                },
                                symbolName: "chevron.backward"
                            )
                            Spacer()
                            BackwardAndForwardButton(
                                action: {
                                    if value < CGFloat(maxPhotoIndex) {
                                        if value == floor(value) {
                                            value += 1
                                        } else {
                                            value = ceil(value)
                                        }
                                    }
                                },
                                symbolName: "chevron.forward"
                            )
                            Spacer()
                            BackwardAndForwardButton(
                                action: { value = CGFloat(maxPhotoIndex) },
                                symbolName: "chevron.forward.2"
                            )
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 48)
                }
            }
        }
        .onAppear {
            value = CGFloat(index)
        }
    }
}

struct TimeLineScreen_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineScreen(
            photoList: Array(Realm.previewRealm.objects(Category.self).first!.photos),
            index: 1
        )
    }
}
