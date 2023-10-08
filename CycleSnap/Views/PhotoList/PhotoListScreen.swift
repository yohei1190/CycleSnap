//
//  PhotoListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import Algorithms
import RealmSwift
import SwiftUI

struct PhotoListScreen: View {
    @ObservedRealmObject var category: Category
    // NOTE: 並び替え時にanimationを追加するため、isLatestをStateとして定義
    @State private var isLatest = false
    @State private var deletingPhoto: Photo?
    @State private var isPresentingDeleteDialog = false
    @State private var isPresentingAlert = false
    @State private var isPresentingCamera = false

    private let screenWidth = UIScreen.main.bounds.size.width
    private let columns: [GridItem] = Array(repeating: .init(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 4), count: 3)

    private var photoList: [Photo] {
        Array(category.photos.sorted(byKeyPath: "captureDate", ascending: !isLatest))
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
            try DocumentsFileHelper.remove(at: deletingPhoto.path)
        } catch {
            print(error.localizedDescription)
        }
    }

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 4) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .scaledToFill()
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .font(.title2)
                                .bold()
                        }
                        .onTapGesture {
                            isPresentingCamera = true
                        }

                    ForEach(photoList.indexed(), id: \.element) { index, photo in
                        if let uiImage = DocumentsFileHelper.loadUIImage(at: photo.path) {
                            NavigationLink {
                                TimeLineScreen(photoList: photoList, index: index)
                            } label: {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth / 3, height: screenWidth / 3)
                                    .clipped()
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
            }

            Spacer()
        }
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
        .fullScreenCover(isPresented: $isPresentingCamera) {
            CameraShootingView(isPresentingCamera: $isPresentingCamera, latestPhotoPath: category.photos.last?.path, category: category)
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
