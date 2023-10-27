//
//  PhotoListTab.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/27.
//

import SwiftUI

struct PhotoListTab: View {
    @State private var isPresentingDeleteDialog = false
    @State private var isPresentingCamera = false
    @State private var isPresentingComparison = false
    @State private var deletingPhoto: Photo?
    @State private var selectedPhoto: Photo?

    @ObservedObject var photoListVM: PhotoListViewModel

    private var photoList: [Photo] {
        photoListVM.photoList
    }

    private let columns: [GridItem] = Array(repeating: .init(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 4), count: 3)

    private func handleTap(_ photo: Photo) {
        selectedPhoto = photo
    }

    private func handleDeleteConfirmation(_ photo: Photo) {
        deletingPhoto = photo
        isPresentingDeleteDialog = true
    }

    private func handleDelete() {
        if let deletingPhoto {
            photoListVM.delete(deletingPhoto)
        }
        deletingPhoto = nil
    }

    private func handleTapCameraStartingButton() {
        isPresentingCamera = true
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(photoList) { photo in
                    if !photo.isInvalidated {
                        PhotoCellView(photo: photo, onTap: handleTap, onDelete: handleDeleteConfirmation)
                    }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            CameraStartingButton(onTap: handleTapCameraStartingButton)
                .padding()
        }
        .confirmationDialog("", isPresented: $isPresentingDeleteDialog) {
            Button("DeletePhoto", role: .destructive, action: handleDelete)
            Button("Cancel", role: .cancel, action: { deletingPhoto = nil })
        }
        .sheet(item: $selectedPhoto) { photo in
            PhotoDetailSheet(selectedPhoto: photo, photoList: photoList)
                .presentationDragIndicator(.visible)
        }
    }
}

struct PhotoListTab_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListTab(photoListVM: PhotoListViewModel(category: PreviewData.category))
    }
}
