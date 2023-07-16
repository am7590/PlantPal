//
//  RemoteImage.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

struct RemoteImage: View {
    let urlString: String
    
    var body: some View {
        if let url = URL(string: urlString),
           let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
    }
}
