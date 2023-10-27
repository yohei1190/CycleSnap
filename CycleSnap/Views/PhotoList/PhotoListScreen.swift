//
//  PhotoListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import SwiftUI

struct PhotoListScreen: View {
    @StateObject var photoListVM: PhotoListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isPresentingDeleteDialog = false
    @State private var isPresentingCamera = false
    @State private var isPresentingComparison = false
    @State private var deletingPhoto: Photo?
    @State private var selectedPhoto: Photo?
    @State private var selectedTab = "photoListTab"

    init(category: Category) {
        _photoListVM = StateObject(wrappedValue: PhotoListViewModel(category: category))
    }

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
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Photo List").tag("photoListTab")
                    Text("Photo Comparison").tag("photoComparisonTab")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TabView(selection: $selectedTab) {
                    PhotoListTab()
                        .tag("photoListTab")

                    PhotoComparisonTab()
                        .tag("photoComparisonTab")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                Spacer()
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
        .fullScreenCover(isPresented: $isPresentingCamera) {
            CameraShootingView(
                category: photoListVM.category,
                latestPhotoPath: photoListVM.category.photos.last?.path
            )
        }
    }
}

struct PhotoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PhotoListScreen(category: PreviewData.category)
        }
    }
}
