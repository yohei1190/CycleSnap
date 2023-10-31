//
//  ComparisonView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/27.
//

import SwiftUI

struct ComparisonView: View {
    @State private var value: CGFloat = 0
    let uiImages: [UIImage]

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                ForEach(uiImages.indexed(), id: \.element) { index, uiImage in
                    Image(uiImage: uiImage)
                        .resizeFourThreeAspectRatio()
                        .opacity(index == 0 ? 1 : value)
                }
            }
            .overlay(alignment: .bottom) {
                SwapButton {
                    value = value < 0.5 ? 1 : 0
                }
                .padding(.bottom)
            }

            Slider(value: $value, in: 0 ... 1, step: 0.1)
                .tint(.primary)
                .padding(.horizontal, 60)

            Spacer()
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView(uiImages: [
            UIImage(named: "previewSample1")!,
            UIImage(named: "previewSample2")!,
        ])
    }
}
