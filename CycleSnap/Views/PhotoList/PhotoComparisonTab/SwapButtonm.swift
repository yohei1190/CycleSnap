//
//  SwapButtonm.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/06.
//

import SwiftUI

struct SwapButton: View {
    let onTap: () -> Void
    let generator = UISelectionFeedbackGenerator()

    var body: some View {
        Button {
            onTap()
            generator.selectionChanged()
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(.black)
                .padding()
                .background(Circle().fill(.white.opacity(0.4)).blur(radius: 8))
                .font(.system(size: 44))
        }
    }
}

struct SwapButton_Previews: PreviewProvider {
    static var previews: some View {
        SwapButton(onTap: {})
            .previewLayout(.sizeThatFits)
    }
}
