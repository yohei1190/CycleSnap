//
//  ComparisonSheetButton.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/18.
//

import SwiftUI

struct ComparisonSheetButton: View {
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Label("ToComparisonScreenLabel", systemImage: "photo.on.rectangle.angled")
                .padding(.vertical, 28)
                .font(.title3)
            Rectangle()
                .fill(.gray.opacity(0.6))
                .frame(height: 1)
        }
        .background(Color("accentBackgroundColor"))
        .ignoresSafeArea(edges: .bottom)
        .onTapGesture(perform: onTap)
    }
}

struct ComparisonSheetButton_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonSheetButton(onTap: {})
    }
}
