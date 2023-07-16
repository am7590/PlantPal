//
//  ImagePageSliderView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/9/23.
//

import SwiftUI

struct ImagePageSliderView: View {
    let images: [UIImage]
    @Binding var currentIndex: Int
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
//                HStack {
//                    Spacer()
//                    Image(systemName: "arrow.up.heart.fill")
//                        .font(.title.bold())
//                        .foregroundColor(.white)
//                        .padding(.top, 35)
//                        .padding(.trailing, 10)
//                }
                
                Spacer()
                
                PageControl(numberOfPages: images.count, currentPage: $currentIndex)
                .padding(.bottom, 30)
                .id(UUID()) // Add an identifier to force recreation of PageControl
            }
        }
        .animation(.linear)
    }
}

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
        pageControl.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        if uiView.numberOfPages != numberOfPages {
            uiView.numberOfPages = numberOfPages
        }
        uiView.currentPage = currentPage
    }
    
    class Coordinator: NSObject {
        var parent: PageControl
        
        init(_ pageControl: PageControl) {
            parent = pageControl
        }
        
        @objc func updateCurrentPage(sender: UIPageControl) {
            parent.currentPage = sender.currentPage
        }
    }
}
