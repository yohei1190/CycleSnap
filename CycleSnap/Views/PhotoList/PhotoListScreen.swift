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

    // NOTE: 並び替え時にanimationを追加するため、isLatestをStateとして定義
    @State private var isLatest = false
    @State private var isPresentingDeleteDialog = false
    @State private var isPresentingCamera = false
    @State private var selectedPhoto: Photo?
    @State private var deletingPhoto: Photo?

    private let columns: [GridItem] = Array(repeating: .init(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 4), count: 3)

    private func handleTap(photo: Photo) {
        withAnimation {
            selectedPhoto = photo
        }
    }

    private func handleDelete(photo: Photo) {
        withAnimation {
            deletingPhoto = photo
            isPresentingDeleteDialog = true
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

                        ForEach(photoListVM.photoList) { photo in
                            PhotoCellView(photo: photo, onTap: handleTap, onDelete: handleDelete)
                        }
                    }
                    Spacer()
                        .frame(minHeight: 80)
                }
                Spacer()
            }

            if photoListVM.photoList.count >= 2 {
                VStack {
                    Spacer()
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
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(photoListVM.category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                PhotoListToolbarMenu(category: photoListVM.category, isLatest: $isLatest)
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
        .fullScreenCover(isPresented: $isPresentingCamera) {
            CameraShootingView(
                isPresentingCamera: $isPresentingCamera,
                latestPhotoPath: photoListVM.photoList.last?.path,
                category: photoListVM.category
            )
        }
        .sheet(item: $selectedPhoto) { photo in
            PhotoCloseUpSheet(photo: photo)
        }
        .onAppear {
            isLatest = photoListVM.category.isLatestFirst
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
