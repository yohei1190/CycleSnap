//
//  PhotoDetailScreen.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/08.
//

import Algorithms
import RealmSwift
import SwiftUI

struct PhotoDetailScreen: View {
    @State private var selection: Int
    let photoList: [Photo]

    init(selection: Int, photoList: [Photo]) {
        _selection = State(wrappedValue: selection)
        self.photoList = photoList
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                ForEach(photoList.indexed(), id: \.element) { index, photo in
                    let url = DocumentsFileHelper.getURL(at: photo.path)
                    AsyncImage(url: url) { image in
                        VStack(spacing: 32) {
                            Text(photo.captureDate, style: .date)
                            image.resizeFourThreeAspectRatio()
                            Spacer()
                        }
                    } placeholder: {
                        ProgressView()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            Spacer()

            Label("\(selection + 1) / \(photoList.count)", systemImage: "photo.stack")
                .font(.title3)
        }
    }
}

struct PhotoCloseUpSheet_Previews: PreviewProvider {
    static let photoList = Realm.previewRealm.objects(Category.self).first!.photos

    static var previews: some View {
        NavigationStack {
            PhotoDetailScreen(selection: 2, photoList: Array(photoList))
        }
    }
}
