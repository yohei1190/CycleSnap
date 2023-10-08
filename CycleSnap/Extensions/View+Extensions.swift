//
//  View+Extensions.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/06.
//

import Foundation
import SwiftUI

struct FourThreeAspectRatio: ViewModifier {
    func body(content: Content) -> some View {
        let viewWidth = UIScreen.main.bounds.width
        let viewHeight = viewWidth * 4 / 3

        return content.frame(width: viewWidth, height: viewHeight)
            .clipped()
    }
}

extension Image {
    func resizeFourThreeAspectRatio() -> some View {
        resizable()
            .scaledToFill()
            .modifier(FourThreeAspectRatio())
    }
}
