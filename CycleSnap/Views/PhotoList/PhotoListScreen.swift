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
    @State private var isPresentingComparison = false
    @State private var deletingPhoto: Photo?
    @State private var selectedPhoto: Photo?

    private let columns: [GridItem] = Array(repeating: .init(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 4), count: 3)

    private func handleDelete(_ photo: Photo) {
        deletingPhoto = photo
        isPresentingDeleteDialog = true
    }

    private func handleTapCameraStartingButton() {
        isPresentingCamera = true
    }

    private func handleTapComparisonButton() {
        isPresentingComparison = true
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 4) {
                    CameraStartingButton(onTap: handleTapCameraStartingButton)

                    ForEach(photoListVM.photoList) { photo in
                        if !photo.isInvalidated {
                            Button(action: { selectedPhoto = photo }) {
                                PhotoCellView(photo: photo, onDelete: handleDelete)
                            }
                        }
                    }
                }
            }
            Spacer()

            if photoListVM.photoList.count >= 2 {
                ComparisonSheetButton(onTap: handleTapComparisonButton)
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
            PhotoDetailSheet(photo: photo, photoList: photoListVM.photoList)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isPresentingComparison) {
            if let firstPhoto = photoListVM.photoList.first,
               let lastPhoto = photoListVM.photoList.last
            {
                ComparisonSheet(
                    firstPhoto: firstPhoto,
                    lastPhoto: lastPhoto
                )
                .presentationDragIndicator(.visible)
            }
        }
        .fullScreenCover(isPresented: $isPresentingCamera) {
            CameraShootingView(
                category: photoListVM.category,
                latestPhotoPath: photoListVM.category.photos.last?.path
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
