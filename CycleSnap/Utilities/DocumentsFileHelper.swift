//
//  DocumentsFileHelper.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import Foundation
import UIKit

struct DocumentsFileHelper {
    private static let photosFolderName = "photos"

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
        let targetURL = getURL(at: relativePath)
        if FileManager.default.fileExists(atPath: targetURL.path()) {
            try FileManager.default.removeItem(at: targetURL)
        }
    }

    static func saveImage(_ image: UIImage, categoryIDString categoryFolderName: String, photoIDString fileNameWithoutExtension: String) throws -> String {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw "Failed to converting jpeg format"
        }

        let categoryFolderURL = URL.documentsDirectory
            .appending(path: photosFolderName, directoryHint: .isDirectory)
            .appending(path: categoryFolderName, directoryHint: .isDirectory)

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: categoryFolderURL.path) {
            try fileManager.createDirectory(at: categoryFolderURL, withIntermediateDirectories: true)
        }

        let fileURL = categoryFolderURL.appendingPathComponent(fileNameWithoutExtension).appendingPathExtension("jpg")
        try data.write(to: fileURL)

        let relativePath = fileURL.path().replacingOccurrences(of: URL.documentsDirectory.path(), with: "")
        return relativePath
    }
}
