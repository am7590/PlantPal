//
//  AlternateItemCell.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 8/31/23.
//

import SwiftUI

struct AlternateItemCell: View {
    var body: some View {
        GeometryReader { proxy in
            let cellWidth = proxy.size.width/2 - 24
           
            HStack {
                VStack(alignment: .leading) {
                    Text("Green Guy")
                        .font(.title2)
                        .bold()
                    Text("Species name")
                        .font(.callout)
                    
                    CircularProgressView(progress: 0.7454, color: .green, size: .small, showProgress: true)
                        .frame(width: proxy.size.width/6, height: proxy.size.width/6)
                        .padding()
                }
                
                Spacer()
                
                Image("succ1")
                    .resizable()
                    .scaledToFill()
                    .modifier(CustomFrameModifier(active: true, width: cellWidth))
                    .clipped()
                    .cornerRadius(16)
                    .shadow(radius: 8.0)
                
                Image(systemName: "chevron.right")
            }
            .padding()
        }
    }
}

struct AlternateItemCell_Previews: PreviewProvider {
    static var previews: some View {
        AlternateItemCell()
    }
}
