//
//  LaunchScreenView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 8/27/23.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject private var splashScreenState: SplashScreenManager
    @State private var startFadeoutAnimation = false
    
    let color1 = Color(red: 238/255, green: 194/255, blue: 119/255)
    let color2 = Color(red: 172/255, green: 106/255, blue: 69/255)
    
    @ViewBuilder
    private var image: some View {
        VStack {
            Image("IconImage")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("PlantPal")
                .font(.custom("Papyrus", fixedSize: 48))
                .bold()
        }
    }
    
    @ViewBuilder
    private var backgroundColor: some View {
        LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .topTrailing)
            .ignoresSafeArea()
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            image
        }
        .opacity(startFadeoutAnimation ? 0 : 1)
    }
    
    private func updateAnimation() {
        switch splashScreenState.launchState {
        case .start:
            ()
        case .dismiss:
            withAnimation(.linear) {
                startFadeoutAnimation = true
            }
        case .finished:
            break
        }
    }
    
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(SplashScreenManager())
    }
}
