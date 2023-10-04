//
//  CameraService.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import AVFoundation
import Foundation

class CameraService {
    var session: AVCaptureSession?
    // 写真をビューに提供するためにdelegateが必要
    var delegate: AVCapturePhotoCaptureDelegate?

    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()

    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> Void) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }

    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }

    func stop() {
        session?.stopRunning()
    }

    private func checkPermissions(completion: @escaping (Error?) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // requestAccessのコールバックはバックグラウンドスレッドで実行される可能性があるため、これに続くUI関連の操作はメインスレッドで実行できるようにディスパッチしている。
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .authorized:
            setupCamera(completion: completion)
        case .restricted:
            break
        case .denied:
            break
        @unknown default:
            break
        }
    }

    private func setupCamera(completion: @escaping (Error?) -> Void) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session

                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
            } catch {
                completion(error)
            }
        }
    }
}
