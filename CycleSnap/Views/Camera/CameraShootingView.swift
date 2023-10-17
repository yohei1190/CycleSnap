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
    @Environment(\.dismiss) private var dismiss

    @StateObject private var cameraVM: CameraViewModel
    @State private var capturedImage: UIImage?
    @State private var overlayOpacity: CGFloat = 0.5
    @State private var isPresentingSettingAlert = false

    let latestPhotoPath: String?

    init(category: Category, latestPhotoPath: String?) {
        _cameraVM = StateObject(wrappedValue: CameraViewModel(category: category))
        self.latestPhotoPath = latestPhotoPath
    }

    var body: some View {
        ZStack {
            ImagePickerView(cameraService: cameraVM.cameraService) { result in
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

            if let latestPhotoPath,
               let uiImage = DocumentsFileHelper.loadUIImage(at: latestPhotoPath)
            {
                Image(uiImage: uiImage)
                    .resizeFourThreeAspectRatio()
                    .opacity(overlayOpacity)
            }

            VStack {
                HStack {
                    Button {
                        cameraVM.stop()
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .frame(minWidth: 44, minHeight: 44)
                    }

                    Spacer()

                    Button(action: cameraVM.switchPosition) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .font(.title2)
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
                    Button(action: cameraVM.capture) {
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
                CameraPreviewView(
                    capturedImage: $capturedImage,
                    cameraVM: cameraVM,
                    dismiss: { dismiss() }
                )
            }
        }
        .onAppear {
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if authorizationStatus == .notDetermined {
                // 初回確認時にdeniedを選択された場合、カメラ画面を閉じる
                cameraVM.cameraService.closeCameraView = { dismiss() }
            } else if authorizationStatus == .denied {
                // denied状態でカメラ画面に再アクセスされた場合、設定画面に飛ばすアラートを出す
                isPresentingSettingAlert = true
            }
        }
        .alert("CameraPermissionAlertTitle", isPresented: $isPresentingSettingAlert) {
            Button("GoToSettings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            Button("Cancel", role: .cancel, action: { dismiss() })
        } message: {
            Text("CameraPermissionAlertMessage")
        }
    }
}

struct CameraShootingView_Previews: PreviewProvider {
    static var previews: some View {
        CameraShootingView(
            category: Realm.previewRealm.objects(Category.self).first!,
            latestPhotoPath: nil
        )
    }
}
