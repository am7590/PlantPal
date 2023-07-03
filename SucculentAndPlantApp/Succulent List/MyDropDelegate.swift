//
//  MyDropDelegate.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/3/23.
//

import SwiftUI

struct MyDropDelegate: DropDelegate {
    let item: Item
    @Binding var items: [Item]
    @State var draggedItem: Item?

    func performDrop(info: DropInfo) -> Bool {
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }

        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!

            withAnimation {
                // Update the position attribute of the objects
                let fromPosition = draggedItem.position
                let toPosition = item.position
                draggedItem.position = toPosition
                item.position = fromPosition

                // Swap the items in the items array
                items.swapAt(from, to)

                // Save the changes to the managed object context
                do {
                    try draggedItem.managedObjectContext?.save()
                    try item.managedObjectContext?.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
        }
    }
}
