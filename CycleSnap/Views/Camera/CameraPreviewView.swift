//
//  CameraPreviewView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import RealmSwift
import SwiftUI

struct CameraPreviewView: View {
    @Binding var capturedImage: UIImage?
    let cameraVM: CameraViewModel
    let dismiss: () -> Void

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
                        if let capturedImage {
                            cameraVM.save(capturedImage)
                        }
                        cameraVM.stop()
                        capturedImage = nil
                        dismiss()
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
    static let category = Realm.previewRealm.objects(Category.self).first!

    static var previews: some View {
        CameraPreviewView(
            capturedImage: .constant(nil),
            cameraVM: CameraViewModel(category: category),
            dismiss: {}
        )
    }
}
