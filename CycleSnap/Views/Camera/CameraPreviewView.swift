//
//  CameraPreviewView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import RealmSwift
import SwiftUI

struct CameraPreviewView: View {
    let cameraService: CameraService
    @Binding var capturedImage: UIImage?
    @Binding var isPresentingCamera: Bool
    @ObservedRealmObject var category: Category

    private func save() {
        guard let capturedImage else { return }

        do {
            let photo = Photo()
            // Documentsに保存
            let savedPath = try DocumentsFileHelper.saveImage(capturedImage, categoryIDString: category._id.stringValue, photoIDString: photo._id.stringValue)
            // Realmに保存
            photo.path = savedPath
            $category.photos.append(photo)
        } catch {
            print(error.localizedDescription)
        }
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if let capturedImage {
                Image(uiImage: capturedImage)
                    .resizeFourThreeAspectRatio()
            }

            VStack {
                Spacer()
                HStack {
                    Button {
                        capturedImage = nil
                    } label: {
                        Text("Retake")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    Spacer()
                    Button {
                        save()

                        cameraService.stop()
                        capturedImage = nil
                        isPresentingCamera = false
                    } label: {
                        Text("Save")
                            .frame(minWidth: 44, minHeight: 44)
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
        CameraPreviewView(
            cameraService: CameraService(),
            capturedImage: .constant(nil),
            isPresentingCamera: .constant(true),
            category: Realm.previewRealm.objects(Category.self).first!
        )
    }
}
