//
//  ImagePickerView.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import AVFoundation
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIViewController

    let cameraService: CameraService
    let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        // カメラを起動する
        cameraService.start(delegate: context.coordinator) { error in
            if let error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
        }

        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        // UI画面にpreviewLayerを追加する
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        // previewLayerを全画面にする
//        cameraService.previewLayer.frame = viewController.view.bounds

        let screenBounds = UIScreen.main.bounds
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
        let previewLayerHeight = screenWidth * 4 / 3
        // 画面の全高からpreviewLayer高を引いて、残った高さを2で割ることで、画面中央に配置できる。
        let yOffset = (screenHeight - previewLayerHeight) / 2

        cameraService.previewLayer.frame = CGRect(x: 0, y: yOffset, width: screenWidth, height: previewLayerHeight)

        return viewController
    }

    func updateUIViewController(_: UIViewControllerType, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: ImagePickerView
        private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> Void

        init(parent: ImagePickerView, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> Void) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }

        // この2番目の引数ラベルが気に入らない
        func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error {
                didFinishProcessingPhoto(.failure(error))
                return
            }

            didFinishProcessingPhoto(.success(photo))
        }
    }
}
