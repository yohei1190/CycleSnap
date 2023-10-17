//
//  PhotoListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import RealmSwift
import SwiftUI

struct PhotoListScreen: View {
    @StateObject var photoListVM: PhotoListViewModel

    init(category: Category) {
        _photoListVM = StateObject(wrappedValue: PhotoListViewModel(category: category))
    }

    @State private var isPresentingDeleteDialog = false
    @State private var isPresentingCamera = false
    @State private var selectedPhoto: Photo?
    @State private var deletingPhoto: Photo?

    private let columns: [GridItem] = Array(repeating: .init(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 4), count: 3)

    private func handleTap(photo: Photo) {
        selectedPhoto = photo
    }

    private func handleDelete(photo: Photo) {
        deletingPhoto = photo
        isPresentingDeleteDialog = true
    }

    private func handleTapCameraStartingButton() {
        isPresentingCamera = true
    }

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 4) {
                    CameraStartingButton(onTap: handleTapCameraStartingButton)

                    ForEach(photoListVM.photoList) { photo in
                        if !photo.isInvalidated {
                            PhotoCellView(photo: photo, onTap: handleTap, onDelete: handleDelete)
                        }
                    }
                }
            }
            Spacer()

            if photoListVM.photoList.count >= 2 {
                HStack {
                    NavigationLink {
                        ComparisonScreen(
                            firstPhoto: photoListVM.photoList.first!,
                            lastPhoto: photoListVM.photoList.last!
                        )
                    } label: {
                        Label("ToComparisonScreenLabel", systemImage: "photo.stack.fill")
                            .padding()
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 40).fill(.blue))
                            .shadow(radius: 4)
                    }
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(photoListVM.category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                PhotoListToolbarMenu(
                    isLatest: photoListVM.category.isLatestFirst,
                    onSort: photoListVM.sort
                )
            }
        }
        .confirmationDialog("", isPresented: $isPresentingDeleteDialog) {
            Button("DeletePhoto", role: .destructive) {
                if let deletingPhoto {
                    photoListVM.delete(deletingPhoto)
                }
                deletingPhoto = nil
            }
            Button("Cancel", role: .cancel) {
                deletingPhoto = nil
            }
        }
        .sheet(item: $selectedPhoto) { photo in
            PhotoCloseUpSheet(photo: photo)
        }
        .fullScreenCover(isPresented: $isPresentingCamera) {
            CameraShootingView(
                isPresentingCamera: $isPresentingCamera,
                latestPhotoPath: photoListVM.category.photos.last?.path,
                category: photoListVM.category
            )
        }
    }
}

struct PhotoListScreen_Previews: PreviewProvider {
    static let category = Realm.previewRealm.objects(Category.self).first!

    static var previews: some View {
        NavigationStack {
            PhotoListScreen(category: category)
        }
    }
}
