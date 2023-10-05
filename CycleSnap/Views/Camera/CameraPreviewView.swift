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

    private func savePhotoToDocuments(directoryName: String, photoName: String) {
        guard let data = capturedImage?.jpegData(compressionQuality: 1) else {
            return
        }

        let folderPath = URL.documentsDirectory.appendingPathComponent(directoryName)

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderPath.path) {
            do {
                try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
        let fileURL = folderPath.appendingPathComponent(photoName)

        do {
            try data.write(to: fileURL)
            print(fileURL.path)
        } catch {
            print("Error writing image data: \(error)")
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
                        let photo = Photo()
                        let directoryName = "photos"
                        let photoName = "\(photo._id).jpg"
                        // Documentsに保存
                        savePhotoToDocuments(directoryName: directoryName, photoName: photoName)

                        // Categoryに保存
                        photo.path = directoryName + "/" + photoName
                        photo.captureDate = Date()
                        $category.photos.append(photo)

                        // 終了処理
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
