//
//  DocumentsFileHelper.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import Foundation
import UIKit

struct DocumentsFileHelper {
    private static let photosFolder = "photos"

    private static func getURL(at relativePath: String) -> URL {
        URL.documentsDirectory.appendingPathComponent(relativePath)
    }

    static func loadUIImage(at relativePath: String) -> UIImage? {
        let imageURL = DocumentsFileHelper.getURL(at: relativePath)
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }
        return UIImage(data: imageData)
    }

    static func remove(at relativePath: String) throws {
        let fileURL = getURL(at: relativePath)
        try FileManager.default.removeItem(at: fileURL)
    }

    static func saveImage(_ image: UIImage, photoIDString fileNameWithoutExtension: String) throws -> String {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw "Failed to converting jpeg format"
        }

        let folderURL = URL.documentsDirectory.appendingPathComponent(photosFolder)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }

        let fileName = fileNameWithoutExtension + ".jpg"
        let fileURL = folderURL.appendingPathComponent(fileName)
        try data.write(to: fileURL)
        return photosFolder + "/" + fileName
    }
}
