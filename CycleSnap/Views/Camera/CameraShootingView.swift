//
//  CameraShootingView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import SwiftUI

struct CameraShootingView: View {
    @Binding var isPresentingCamera: Bool
    @Binding var capturedImage: UIImage?

    let cameraService = CameraService()

    var body: some View {
        ZStack {
            ImagePickerView(cameraService: cameraService) { result in
                switch result {
                case let .success(photo):
                    if let data = photo.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                    } else {
                        print("Error: no image data found")
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button("X") {
                        cameraService.stop()
                        isPresentingCamera = false
                    }
                }
                Spacer()
                Button {
                    cameraService.capturePhoto()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 65, height: 65)
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .frame(width: 75, height: 75)
                    }
                }
            }
            .padding(.bottom, 60)
        }
        .ignoresSafeArea()
        .overlay {
            if capturedImage != nil {
                CameraPreviewView(cameraService: cameraService, capturedImage: $capturedImage, isPresentingCamera: $isPresentingCamera)
            }
        }
    }
}

struct CameraShootingView_Previews: PreviewProvider {
    static var previews: some View {
        CameraShootingView(isPresentingCamera: .constant(true), capturedImage: .constant(nil))
    }
}
