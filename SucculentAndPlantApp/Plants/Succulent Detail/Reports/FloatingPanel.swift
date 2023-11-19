//
//  FloatingPanel.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 7/16/23.
//

import SwiftUI

struct FloatingPanel<Content: View>: View {
    @Binding var isPresented: Bool
    let content: () -> Content
    
    var body: some View {
        VStack {
            Spacer()
            content()
                .frame(height: 300)
                .cornerRadius(16)
                .padding()
                .hoverEffect()
                .shadow(color: Color(UIColor.systemGray4), radius: 4.0, x: 0, y: 2)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .onTapGesture {
            isPresented = false
        }
    }
}
