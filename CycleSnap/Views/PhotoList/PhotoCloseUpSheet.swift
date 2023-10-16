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

    let photo: Photo

    var body: some View {
        NavigationStack {
            VStack {
                if let uiImage = DocumentsFileHelper.loadUIImage(at: photo.path) {
                    Image(uiImage: uiImage)
                        .resizeFourThreeAspectRatio()
                    Spacer()
                }
            }
            .padding(.bottom, 32)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(photo.captureDate, style: .date)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
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
        PhotoCloseUpSheet(photo: photo)
    }
}
