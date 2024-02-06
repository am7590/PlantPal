//
//  Modifiers.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/9/23.
//

import SwiftUI

// Toggle between list or grid image frames
struct CustomFrameModifier: ViewModifier {
    var active: Bool
    var width: CGFloat
    
    @ViewBuilder func body(content: Content) -> some View {
        if active {
            content.frame(width: width, height: width, alignment: .center)
        } else {
            HStack {
                
                content.frame(width: width, height: width, alignment: .center)
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(16)
                    .shadow(radius: 8.0)
                
                
                VStack(alignment: .leading) {
                    
                    Group {
                        Text("Spikey Guy").font(.title3).bold()
                            .padding(.leading)

                        Text("Bergeranthus concavus").font(.subheadline).italic()
                            .padding(.leading)

                    }
//                    .padding(.top)
               
                    Spacer()
                    HStack {
                        
                        Spacer()
                        VStack {
                            Spacer()
                            CircularProgressView(progress: 0.55, color: Color(uiColor: .systemGreen), size: .small, showProgress: true)
                                .frame(width: 60, height: 60)
                            Spacer()
                            Text("Healthy")
                                .font(.caption.bold())
                            Spacer()
                        }
                        .padding(.leading, 22)

                        Spacer()
                    }
                 
                    Spacer()
                    
                }
               
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
