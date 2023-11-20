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
            HStack {
                
                VStack(alignment: .leading) {
                    Group {
                        Text("Spikey Guy").font(.title3).bold()
                            .padding(.leading)

                        Text("Bergeranthus concavus").italic()
                            .padding(.leading)

                    }
               
                    Spacer()
                    HStack {
                        VStack {
                            CircularProgressView(progress: 0.04, color: .red, size: .small, showProgress: true)
                                .frame(width: 50, height: 50)
                            Text("Health")
                                .font(.caption.bold())
                        }
                        .padding(.leading, 22)

                        Spacer()
                    }
                 
                    Spacer()
                    
                }
                content.frame(width: width, height: width, alignment: .center)
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(16)
                    .shadow(radius: 8.0)
                
            }
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
