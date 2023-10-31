//
//  PhotoComparisonTab.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/08.
//

import Algorithms
import SwiftUI

struct PhotoComparisonTab: View {
    let photoList: [Photo]

    var body: some View {
        if photoList.count >= 2 {
            if let firstPhoto = photoList.first, let lastPhoto = photoList.last {
                let uiImages = [firstPhoto, lastPhoto].compactMap { DocumentsFileHelper.loadUIImage(at: $0.path)
                }
                ComparisonView(uiImages: uiImages)
            }
        } else {
            Text("写真を2枚以上撮影すると、写真の比較を行うことができます")
                .padding()
        }
    }
}

#if DEBUG
    struct PhotoComparisonTab_Previews: PreviewProvider {
        static var previews: some View {
            PhotoComparisonTab(photoList: Array(PreviewData.photoList))
        }
    }
#endif
