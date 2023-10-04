//
//  FileHelper.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import Foundation
import UIKit

struct FileHelper {
    static func getFileURL(path: String) -> URL {
        URL.documentsDirectory.appendingPathComponent(path)
    }

    static func loadImage(_ path: String) -> UIImage? {
        let imageURL = FileHelper.getFileURL(path: path)
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
