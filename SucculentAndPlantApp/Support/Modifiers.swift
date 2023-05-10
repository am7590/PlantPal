//
//  Modifiers.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI


/// Toggle between list or grid image frames
struct CustomFrameModifier: ViewModifier {
    var active: Bool
    var width: CGFloat
    
    @ViewBuilder func body(content: Content) -> some View {
        if active {
            content.frame(width: width, height: width, alignment: .center)
        } else {
            content
        }
    }
}

//struct CustomListModifier: ViewModifier {
//    var viewModel: SucculentListViewModel
//    var cellWidth: CGFloat
//
//    var gridItemLayout = [GridItem(.adaptive(minimum: 150))]
//
//    func body(content: Content) -> some View {
//        if viewModel.isList {
//            content
//        } else {
//            LazyVGrid(columns: gridItemLayout, spacing: 16) {
//                content
//            }
//        }
//
//    }
//}
