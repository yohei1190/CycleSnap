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
        Circle()
            .fill(Color.blue)
            .scaledToFill()
            .overlay {
                Image(systemName: "camera")
                    .foregroundColor(.white)
                    .font(.title)
            }
            .frame(width: 80, height: 80)
            .onTapGesture(perform: onTap)
    }
}

struct CameraStartingButton_Previews: PreviewProvider {
    static var previews: some View {
        CameraStartingButton(onTap: {})
    }
}
