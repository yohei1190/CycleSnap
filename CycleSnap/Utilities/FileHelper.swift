//
//  FileHelper.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import Foundation

struct FileHelper {
    static func getFileURL(path: String) -> URL {
        URL.documentsDirectory.appendingPathComponent(path)
    }
}
