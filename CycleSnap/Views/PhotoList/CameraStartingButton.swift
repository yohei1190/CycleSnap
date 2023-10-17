//
//  CameraStartingButton.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/17.
//

import SwiftUI

struct CameraStartingButton: View {
    let onTap: () -> Void

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .scaledToFill()
            .overlay {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .bold()
            }
            .onTapGesture {}
    }
}

struct CameraStartingButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraStartingButton(onTap: {})
    }
}
