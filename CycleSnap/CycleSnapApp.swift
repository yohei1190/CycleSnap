//
//  CycleSnapApp.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/20.
//

import SwiftUI

@main
struct CycleSnapApp: App {
    let migrator = RealmConfiguration()

    var body: some Scene {
        WindowGroup {
            // TODO: debug用のパスは最後に削除する
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)

            ContentView()
        }
    }
}
