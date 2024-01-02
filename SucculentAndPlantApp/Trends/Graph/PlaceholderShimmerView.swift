//
//  PlaceholderShimmerView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 12/23/23.
//

import SwiftUI
import Shimmer


struct PlaceholderShimmerView: View {
    var body: some View {
        Section {
            VStack {
                Image("IconImage")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .cornerRadius(12)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Spikey Guy").font(.title3).bold()
                        Text("Bergeranthus concavus").italic()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image("IconImage")
                            .foregroundColor(.secondary)
                            .frame(width: 48, height: 48)
                            .mask(Circle())

                        Text("Unhealthy")
                            .font(.caption.bold())
                    }
                    .padding()
                }
            }
        }
        .redacted(reason: .placeholder)
        .shimmer()
    }
}

struct PlaceholderShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderShimmerView()
    }
}
