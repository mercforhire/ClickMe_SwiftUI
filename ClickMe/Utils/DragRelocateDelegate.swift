//
//  DragRelocateDelegate.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-09.
//

import Foundation
import SwiftUI

struct DragRelocateDelegate: DropDelegate {
    let destinationItem: Photo
    @Binding var photos: [Photo]
    @Binding var draggedItem: Photo?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Swap Items
        if let draggedItem {
            let fromIndex = photos.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = photos.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.photos.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}
