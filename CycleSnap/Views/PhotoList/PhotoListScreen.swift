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
    @State private var isPresentingDeleteDialog = false
    @State private var isPresentingAlert = false
    @State private var isPresentingCamera = false
    @State private var deletingPhoto: Photo?
    @State private var selectedPhoto: IndexedPhoto?

    private let screenWidth = UIScreen.main.bounds.size.width
    private let columns: [GridItem] = Array(repeating: .init(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 4), count: 3)

    private var indexedPhotoList: [IndexedPhoto] {
        category.photos
            .sorted(byKeyPath: "captureDate", ascending: !isLatest)
            .enumerated()
            .map { index, photo in
                IndexedPhoto(id: index, photo: photo)
            }
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
        ZStack {
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

                        ForEach(indexedPhotoList) { indexedPhoto in
                            let photo = indexedPhoto.photo
                            if let uiImage = DocumentsFileHelper.loadUIImage(at: photo.path) {
                                Button {
                                    selectedPhoto = indexedPhoto
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
                    Spacer()
                        .frame(minHeight: 80)
                }
                Spacer()
            }

            if indexedPhotoList.count >= 2 {
                VStack {
                    Spacer()
                    HStack {
                        NavigationLink {
                            ComparisonScreen(firstPhoto: indexedPhotoList.first!.photo, lastPhoto: indexedPhotoList.last!.photo)
                        } label: {
                            Label("ToComparisonScreenLabel", systemImage: "photo.stack.fill")
                                .padding()
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 40).fill(.blue))
                                .shadow(radius: 4)
                        }
                    }
                }
                .padding(.bottom)
            }
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
            Button("DeletePhoto", role: .destructive) {
                delete()
                deletingPhoto = nil
            }
            Button("Cancel", role: .cancel) {
                deletingPhoto = nil
            }
        }
        .overlay {
            CategoryNameAlert(isPresenting: $isPresentingAlert, existingCategory: category)
        }
        .fullScreenCover(isPresented: $isPresentingCamera) {
            CameraShootingView(isPresentingCamera: $isPresentingCamera, latestPhotoPath: category.photos.last?.path, category: category)
        }
        .sheet(item: $selectedPhoto) { indexedPhoto in
            PhotoCloseUpSheet(indexedPhoto: indexedPhoto, count: indexedPhotoList.count)
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
