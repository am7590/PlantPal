//
//  RemoteImage.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

// Stores images for id + health check detail views
struct RemoteImage: View {
    let url: URL
    @State private var image: UIImage? = nil

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
                    .onAppear {
                        fetchImage()
                    }
            }
        }
    }

    private func fetchImage() {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let fetchedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = fetchedImage
                    ImageCacheManager.shared.setImage(fetchedImage, forKey: url.absoluteString)
                }
            }
        }.resume()
    }
}
