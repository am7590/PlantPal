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
            GeometryReader { proxy in
                let width = proxy.size.width
                
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: 300, alignment: .center)
                            .tag(index)
                            .clipped()
                            .cornerRadius(16)
                            .shadow(radius: 4.0)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeOut(duration: 0.5))
                .padding(.horizontal, -20) 
                
                VStack {
                    Spacer()
                    
                    PageControl(numberOfPages: images.count, currentPage: $currentIndex)
                        .padding(.bottom, -50)
                        .animation(.default, value: UUID())
                }
            }
        }
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
        pageControl.backgroundStyle = .prominent
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
