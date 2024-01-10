//
//  View+Ext.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import Foundation
import SwiftUI

extension View {
    func reorderableForEachContainer<Item: Reorderable>(active: Binding<Item?>) -> some View {
        onDrop(of: [.text], delegate: ReorderableDropOutsideDelegate(active: active))
    }
}
