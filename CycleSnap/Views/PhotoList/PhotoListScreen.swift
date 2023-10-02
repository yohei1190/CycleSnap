//
//  PhotoListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import RealmSwift
import SwiftUI

struct PhotoListScreen: View {
    @ObservedRealmObject var category: Category
    // NOTE: 並び替え時にanimationを追加するため、isLatestをStateとして定義
    @State private var isLatest = false
    @State private var deletingPhoto: Photo?
    @State private var isPresentingDeleteDialog = false
    @State private var isPresentingAlert = false

    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)

    private func loadImage(_ path: String) -> UIImage? {
        let imageURL = FileHelper.getFileURL(path: path)
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }

        return UIImage(data: imageData)
    }

    private func delete() {
        guard let deletingPhoto else { return }

        do {
            // NOTE: RealmDBからオブジェクトを削除
            let realm = try Realm()
            guard let photoObject = realm.object(ofType: Photo.self, forPrimaryKey: deletingPhoto._id) else {
                return
            }

            try realm.write {
                realm.delete(photoObject)
            }
            // NOTE: Documentsディレクトリから画像ファイルを削除
            let imageURL = FileHelper.getFileURL(path: deletingPhoto.path)
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print(error.localizedDescription)
        }
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(1, contentMode: .fill)
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .font(.title2)
                                .bold()
                        }

                    ForEach(category.photos.sorted(byKeyPath: "captureDate", ascending: !isLatest)) { photo in
                        if let uiImage = loadImage(photo.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .overlay(alignment: .bottomTrailing) {
                                    Text(photo.captureDate, style: .date)
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .background(.black.opacity(0.4))
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        isPresentingDeleteDialog = true
                                        deletingPhoto = photo
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(category.name)
        .navigationBarBackButtonHidden(isPresentingAlert ? true : false)
        .toolbar {
            if !isPresentingAlert {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotoListToolbarMenu(category: category, isLatest: $isLatest, isPresentingAlert: $isPresentingAlert)
                }
            }
        }
        .confirmationDialog("", isPresented: $isPresentingDeleteDialog) {
            Button("Delete photo", role: .destructive) {
                delete()
                deletingPhoto = nil
            }
        }
        .overlay {
            CategoryNameAlert(isPresenting: $isPresentingAlert, existingCategory: category)
        }
        .onAppear {
            isLatest = category.isLatestFirst
        }
    }
}

struct PhotoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PhotoListScreen(category: Realm.previewRealm.objects(Category.self).first!)
        }
    }
}
