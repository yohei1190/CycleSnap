//
//  PhotoListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import SwiftUI

struct PhotoListScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var photoListVM: PhotoListViewModel

    @State private var selectedTab = "photoListTab"

    init(category: Category) {
        _photoListVM = StateObject(wrappedValue: PhotoListViewModel(category: category))
    }

    private var photoList: [Photo] {
        photoListVM.photoList
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("PhotoListPickerLabel").tag("photoListTab")
                    Text("PhotoComparisonPickerLabel").tag("photoComparisonTab")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TabView(selection: $selectedTab) {
                    PhotoListTab(photoListVM: photoListVM)
                        .tag("photoListTab")

                    PhotoComparisonTab(photoList: photoList)
                        .tag("photoComparisonTab")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                Spacer()
            }
            .navigationTitle(photoListVM.category.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.backward")
                                .bold()
                            Text("Back")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotoListToolbarMenu(
                        isLatest: photoListVM.category.isLatestFirst,
                        onSort: photoListVM.sort
                    )
                }
            }
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
