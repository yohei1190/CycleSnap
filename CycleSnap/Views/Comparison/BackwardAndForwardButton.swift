//
//  BackwardAndForwardButton.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/06.
//

import SwiftUI

struct BackwardAndForwardButton: View {
    let onTap: () -> Void
    let symbolName: String
    let generator = UISelectionFeedbackGenerator()

    var body: some View {
        Button {
            onTap()
            generator.selectionChanged()
        } label: {
            Image(systemName: symbolName)
                .foregroundColor(.primary)
                .font(.system(size: 44))
        }
    }
}

struct BackwardAndForwardButton_Previews: PreviewProvider {
    static var previews: some View {
        BackwardAndForwardButton(
            onTap: {},
            symbolName: "arrow.left.circle.fill"
        )
        .previewLayout(.sizeThatFits)
    }
}
