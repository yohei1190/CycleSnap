//
//  CameraViewModel.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/17.
//

import Foundation
import RealmSwift
import UIKit

final class CameraViewModel: ObservableObject {
    let category: Category
    let cameraService: CameraService = .init()
    private let realm: Realm = try! Realm()

    init(category: Category) {
        self.category = category
    }

    func stop() {
        cameraService.stop()
    }

    func switchPosition() {
        cameraService.switchCamera()
    }

    func capture() {
        cameraService.capturePhoto()
    }

    func save(_ uiImage: UIImage) {
        do {
            let photo = Photo()

            let savedPath = try DocumentsFileHelper.saveImage(uiImage, categoryIDString: category._id.stringValue, photoIDString: photo._id.stringValue)

            photo.path = savedPath
            try realm.write {
                category.photos.append(photo)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
