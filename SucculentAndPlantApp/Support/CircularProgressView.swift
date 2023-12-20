//
//  CircularProgressView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/19/23.
//

import SwiftUI

enum CircularProgressViewSize { case small, large }

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let size: CircularProgressViewSize
    let showProgress: Bool
    
    var body: some View {
        ZStack {
            if showProgress {
                Text("\(String(format: "%.\(size == .large ? "2" : "")f", progress*100))%")
                    .font(size == .large ? .title3.bold() : .caption.bold())
                    .foregroundColor(color)
            }
            
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: size == .large ? 22.0 : 12.0
                )
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: size == .large ? 22.0 : 12.0,
                        lineCap: .round
                    )
                )
                .animation(.linear(duration: 10), value: progress)
                .rotationEffect(.degrees(-90))
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.69, color: .green, size: .small, showProgress: true)
            .frame(width: 50, height: 50)
    }
}
