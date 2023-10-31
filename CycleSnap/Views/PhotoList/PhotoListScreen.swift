//
//  PhotoListScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/28.
//

import SwiftUI

struct PhotoListScreen: View {
    @StateObject var photoListVM: PhotoListViewModel

    @State private var selectedTab = "photoListTab"

    init(category: Category) {
        _photoListVM = StateObject(wrappedValue: PhotoListViewModel(category: category))
    }

    private var photoList: [Photo] {
        photoListVM.photoList
    }

    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("写真一覧").tag("photoListTab")
                Text("新旧写真比較").tag("photoComparisonTab")
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
            ToolbarItem(placement: .navigationBarTrailing) {
                PhotoListToolbarMenu(
                    isLatest: photoListVM.category.isLatestFirst,
                    onSort: photoListVM.sort
                )
            }
        }
    }
}

struct PhotoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListScreen(category: PreviewData.category)
    }
}
