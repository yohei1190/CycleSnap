//
//  FileHelper.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import Foundation
import UIKit

struct FileHelper {
    static let photosFolder = "photos"

    static func getFileURLInDocuments(path: String) -> URL {
        URL.documentsDirectory.appendingPathComponent(path)
    }

    static func loadImage(_ path: String) -> UIImage? {
        let imageURL = FileHelper.getFileURLInDocuments(path: path)
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }
        return UIImage(data: imageData)
    }

    static func removePhotoInDocuments(path: String) throws {
        let imageURL = getFileURLInDocuments(path: path)
        try FileManager.default.removeItem(at: imageURL)
    }

    static func savePhotoToDocuments(image: UIImage?, photoIDString: String) throws -> String {
        guard let data = image?.jpegData(compressionQuality: 1) else {
            throw "jpeg形式の変換に失敗"
        }

        let folderPath = URL.documentsDirectory.appendingPathComponent(photosFolder)

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderPath.path) {
            try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true)
        }
        let photoName = photoIDString + "/" + ".jpg"
        let fileURL = folderPath.appendingPathComponent(photoName)

        try data.write(to: fileURL)
        return photosFolder + photoName
    }
}
