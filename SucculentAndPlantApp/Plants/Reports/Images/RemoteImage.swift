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
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        if let cachedImage = ImageCacheManager.shared.getImage(forKey: url.absoluteString) {
            print("Loaded image from cache: \(url)")
            self.image = cachedImage
        } else {
            fetchImage()
        }
    }

    private func fetchImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            if let data = data, let fetchedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = fetchedImage
                    ImageCacheManager.shared.setImage(fetchedImage, forKey: url.absoluteString)
                    print("Downloaded and cached image: \(url)")
                }
            } else {
                print("Failed to load image data for URL: \(url)")
            }
        }.resume()
    }
}
