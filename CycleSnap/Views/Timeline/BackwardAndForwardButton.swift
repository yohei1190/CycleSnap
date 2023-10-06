//
//  BackwardAndForwardButton.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/06.
//

import SwiftUI

struct BackwardAndForwardButton: View {
    let action: () -> Void
    let symbolName: String
    let generator = UISelectionFeedbackGenerator()

    var body: some View {
        Button(action: {
            action()
            generator.selectionChanged()
        }) {
            Image(systemName: symbolName)
                .frame(width: 44, height: 44)
                .background(Circle().fill(.white.opacity(0.15)))
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}

struct BackwardAndForwardButton_Previews: PreviewProvider {
    static var previews: some View {
        BackwardAndForwardButton(action: {}, symbolName: "chevron.backward.2")
            .previewLayout(.sizeThatFits)
    }
}
