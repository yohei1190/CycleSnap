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
    let isLatest: Bool
    let onSort: (SortOrder) -> Void

    var body: some View {
        Menu {
            Button(action: { onSort(.oldest) }) {
                Text("OldestFirst")
                if !isLatest {
                    Image(systemName: "checkmark")
                }
            }

            Button(action: { onSort(.latest) }) { Text("NewestFirst")
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
            isLatest: true,
            onSort: { _ in }
        )
    }
}
