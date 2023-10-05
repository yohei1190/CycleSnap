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
        do {
            let photo = Photo()
            photo.captureDate = Date()
            // Documentsに保存
            let savedPath = try FileHelper.savePhotoToDocuments(image: capturedImage, photoIDString: photo._id.stringValue)

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
                let viewWidth = UIScreen.main.bounds.width
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
                        save()

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
        CameraPreviewView(cameraService: CameraService(), capturedImage: .constant(nil), isPresentingCamera: .constant(true), category: Realm.previewRealm.objects(Category.self).first!)
    }
}
