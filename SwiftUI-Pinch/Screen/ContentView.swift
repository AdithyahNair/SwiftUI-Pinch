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
    @State private var imageOffset: CGSize = .zero

    // MARK: - Function

    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("magazine-front-cover")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .padding(20)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            if imageScale == 1 {
                                withAnimation(.spring()) {
                                    imageScale = 5
                                }
                            } else {
                                resetImageState()
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = gesture.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
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
