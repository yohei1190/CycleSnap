//
//  CameraPreviewView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import SwiftUI

struct CameraPreviewView: View {
    let cameraService: CameraService
    @Binding var capturedImage: UIImage?
    @Binding var isPresentingCamera: Bool

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if let capturedImage {
                let viewWidth = UIScreen.main.bounds.width // 画面の幅を取得
                let viewHeight = viewWidth * 4 / 3

                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: viewWidth, height: viewHeight)
                    .clipped()
            }

            VStack {
                Spacer()
                HStack {
                    Button("Retake") {
                        capturedImage = nil
                    }
                    Spacer()
                    Button("Save") {
                        // save
                        cameraService.stop()
                        capturedImage = nil
                        isPresentingCamera = false
                    }
                }
                .foregroundColor(.white)
                .font(.title3)
                .padding(.horizontal, 40)
                .padding(.bottom, 52)
            }
        }
    }
}

struct CameraPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        CameraPreviewView(cameraService: CameraService(), capturedImage: .constant(UIImage(named: "sample")), isPresentingCamera: .constant(true))
    }
}
