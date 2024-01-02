//
//  ImageCacheManager.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 1/1/24.
//

import UIKit
import os

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
