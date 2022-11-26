//
//  ContentView.swift
//  SwiftUI-Pinch
//
//  Created by Adithyah Nair on 26/11/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties

    @State private var isAnimating: Bool = false
    @State private var imageScale: Double = 1

    var body: some View {
        NavigationView {
            ZStack {
                Image("magazine-front-cover")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .scaleEffect(imageScale)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .padding()
                    .animation(.linear(duration: 1), value: isAnimating)
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            if imageScale == 1 {
                                imageScale = 5
                            } else {
                                imageScale = 1
                            }
                        }
                    }
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
