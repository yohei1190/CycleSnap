//
//  PhotoDetailSheet.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/08.
//

import Algorithms
import SwiftUI

struct PhotoDetailSheet: View {
    @State private var selection: Int
    let photoList: [Photo]

    init(selectedPhoto: Photo, photoList: [Photo]) {
        let selectedPhotoIndex = photoList.firstIndex(of: selectedPhoto)!
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

#if DEBUG
    struct PhotoDetailSheet_Previews: PreviewProvider {
        static var previews: some View {
            PhotoDetailSheet(selectedPhoto: PreviewData.photo, photoList: Array(PreviewData.photoList))
        }
    }
#endif
