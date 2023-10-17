//
//  PhotoListToolbarMenu.swift
//  CycleSnap
//
//  Created by yohei shimizu on 2023/09/29.
//

import RealmSwift
import SwiftUI

enum SortOrder {
    case latest
    case oldest
}

struct PhotoListToolbarMenu: View {
    @Binding var isLatest: Bool
    let onSort: (SortOrder) -> Void

    var body: some View {
        Menu {
            Button {
                onSort(.oldest)
                withAnimation {
                    isLatest = false
                }
            } label: {
                Text("OldestFirst")
                if !isLatest {
                    Image(systemName: "checkmark")
                }
            }

            Button {
                onSort(.latest)
                withAnimation {
                    isLatest = true
                }
            } label: {
                Text("NewestFirst")
                if isLatest {
                    Image(systemName: "checkmark")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title2)
        }
    }
}

struct PhotoListToolbarMenuToolbarMenu_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListToolbarMenu(
            isLatest: .constant(true),
            onSort: { _ in }
        )
    }
}
