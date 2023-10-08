//
//  PhotoCloseUpSheet.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/10/08.
//

import RealmSwift
import SwiftUI

struct PhotoCloseUpSheet: View {
    @Environment(\.dismiss) private var dismiss

    let indexedPhoto: IndexedPhoto
    let count: Int

    var body: some View {
        NavigationStack {
            VStack {
                if let uiImage = DocumentsFileHelper.loadUIImage(at: indexedPhoto.photo.path) {
                    Image(uiImage: uiImage)
                        .resizeFourThreeAspectRatio()
                    Spacer()

                    Label("\(indexedPhoto.id + 1) / \(count)", systemImage: "photo")
                        .font(.title3)
                }
            }
            .padding(.bottom, 32)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(indexedPhoto.photo.captureDate, style: .date)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Text("Close")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
            }
        }
    }
}

struct PhotoCloseUpSheet_Previews: PreviewProvider {
    static let photo = Realm.previewRealm.objects(Category.self).first!.photos.first!
    static var previews: some View {
        PhotoCloseUpSheet(
            indexedPhoto: IndexedPhoto(id: 0, photo: photo),
            count: 3
        )
    }
}
