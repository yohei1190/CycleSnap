//
//  String+Extensions.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/05.
//

#if DEBUG
    import Foundation

    extension String: LocalizedError {
        public var errorDescription: String? {
            self
        }
    }
#endif
