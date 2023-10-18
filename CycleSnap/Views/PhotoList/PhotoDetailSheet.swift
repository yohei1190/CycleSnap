//
//  PhotoDetailSheet.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/08.
//

import Algorithms
import RealmSwift
import SwiftUI

struct PhotoDetailSheet: View {
    @State private var selection: Int
    let photoList: [Photo]

    init(photo: Photo, photoList: [Photo]) {
        let selectedPhotoIndex = photoList.firstIndex(of: photo)!
        _selection = State(wrappedValue: selectedPhotoIndex)
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
        }
        .padding(.vertical, 40)
    }
}

struct PhotoDetailSheet_Previews: PreviewProvider {
    static let photoList = Realm.previewRealm.objects(Category.self).first!.photos

    static var previews: some View {
        PhotoDetailSheet(photo: photoList.first!, photoList: Array(photoList))
    }
}
