//
//  ImageSliderContainer.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/10/23.
//

import UIKit
import SwiftUI

struct ImageSliderContainerView: View {
    var imgArr: [UIImage]
    
    var body: some View {
        ImageSliderContainer(imgArr: imgArr)
            //.padding()
            //.cornerRadius(24)
        
        //.edgesIgnoringSafeArea(.all)
    }
}

struct ImageSliderContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSliderContainerView(imgArr: [])
    }
}

struct ImageSliderContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImageSliderViewController
    
    var imgArr: [UIImage]
    
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
