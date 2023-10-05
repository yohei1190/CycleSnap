//
//  CameraShootingView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import AVFoundation
import RealmSwift
import SwiftUI

struct CameraShootingView: View {
    @Binding var isPresentingCamera: Bool
    @State private var capturedImage: UIImage?
    @State private var overlayOpacity: CGFloat = 0.5
    @State private var isPresentingAlert = false

    let latestPhotoPath: String?
    let cameraService = CameraService()
    @ObservedRealmObject var category: Category

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

            if let latestPhotoPath, let uiImage = FileHelper.loadImage(latestPhotoPath) {
                let viewWidth = UIScreen.main.bounds.width
                let viewHeight = viewWidth * 4 / 3
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: viewWidth, height: viewHeight)
                    .clipped()
                    .opacity(overlayOpacity)
            }

            VStack {
                HStack {
                    Button("Cancel") {
                        cameraService.stop()
                        isPresentingCamera = false
                    }

                    Spacer()

                    Button {
                        cameraService.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                    }
                    .font(.title)
                }
                .foregroundColor(.white)

                Spacer()

                if latestPhotoPath != nil {
                    Slider(value: $overlayOpacity)
                        .padding(.bottom, 40)
                        .tint(.white)
                }

                HStack {
                    Spacer()
                    Button {
                        cameraService.capturePhoto()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 60, height: 60)
                            Circle()
                                .stroke(.white, lineWidth: 5)
                                .frame(width: 75, height: 75)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 72)
        }
        .ignoresSafeArea()
        .overlay {
            if capturedImage != nil {
                CameraPreviewView(cameraService: cameraService, capturedImage: $capturedImage, isPresentingCamera: $isPresentingCamera, category: category)
            }
        }
        .onAppear {
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if authorizationStatus == .notDetermined {
                // 初回確認時にdeniedを選択された場合、カメラ画面を閉じる
                cameraService.closeCameraView = {
                    isPresentingCamera = false
                }
            } else if authorizationStatus == .denied {
                // denied状態でカメラ画面に再アクセスされた場合、設定画面に飛ばすアラートを出す
                isPresentingAlert = true
            }
        }
        .alert("Allow CycleSpan access to your camera", isPresented: $isPresentingAlert) {
            Button("Go to settings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            Button("Cancel", role: .cancel) {
                isPresentingCamera = false
            }
        } message: {
            Text("Camera access lets you take photos. You can change this access later in your system settings.")
        }
    }
}

struct CameraShootingView_Previews: PreviewProvider {
    static var previews: some View {
        CameraShootingView(isPresentingCamera: .constant(true), latestPhotoPath: nil, category: Realm.previewRealm.objects(Category.self).first!)
    }
}
