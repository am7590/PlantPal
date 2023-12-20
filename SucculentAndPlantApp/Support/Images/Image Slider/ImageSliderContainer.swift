//
//  ImageSliderContainer.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/10/23.
//

import UIKit
import SwiftUI

struct ImageSliderContainerView: View {
    @ObservedObject var viewModel: SuccuelentFormViewModel
    
    var body: some View {
        ImageSliderContainer(imgArr: $viewModel.uiImage)
    }
}

struct ImageSliderContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImageSliderViewController
    
    @Binding var imgArr: [UIImage]
    
    func makeUIViewController(context: Context) -> ImageSliderViewController {
        let storyboard = UIStoryboard(name: "ImageSlider", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "slide") as! ImageSliderViewController
        controller.imgArr = imgArr
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ImageSliderViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
