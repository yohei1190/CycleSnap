//
//  CameraService.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/04.
//

import AVFoundation
import Foundation

class CameraService {
    var session = AVCaptureSession()
    // 写真をビューに提供するためにdelegateが必要
    var delegate: AVCapturePhotoCaptureDelegate?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    var closeCameraView: (() -> Void)?

    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> Void) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }

    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }

    func switchCamera() {
        session.beginConfiguration()

        let newDevice: AVCaptureDevice?

        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            if currentInput.device.position == .front {
                newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            } else {
                newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            }
        } else {
            newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        // 現在の入力を取得して削除
        for input in session.inputs {
            session.removeInput(input)
        }

        // 新しい入力を作成して追加
        if let newDevice {
            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                if session.canAddInput(newInput) {
                    session.addInput(newInput)
                }
            } catch {
                print("Failed to create input for new device: \(error)")
            }
        } else {
            print("Could not find camera device")
        }
        session.commitConfiguration()
    }

    func stop() {
        session.stopRunning()
    }

    private func checkPermissions(completion: @escaping (Error?) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // requestAccessのコールバックはバックグラウンドスレッドで実行される可能性があるため、これに続くUI関連の操作はメインスレッドで実行できるようにディスパッチしている。
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera(completion: completion)
                    } else {
                        self?.closeCameraView?()
                    }
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
                    self.session.startRunning()
                }
            } catch {
                completion(error)
            }
        }
    }
}
