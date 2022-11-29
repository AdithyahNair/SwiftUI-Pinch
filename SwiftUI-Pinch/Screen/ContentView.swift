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

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear

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
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    } else {
                                        resetImageState()
                                    }
                                }
                                
                            })
                            .onEnded({ _ in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale > 5 {
                                        imageScale = 5
                                    } else {
                                        resetImageState()
                                    }
                                }
                            })
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }

            // MARK: - Info Panel

            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset) // Use Color.clear to make sure view is on top of ZStack
                    .padding(20)
                , alignment: .top
            )

            // MARK: - Control Panel

            .overlay(
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            if imageScale > 1 {
                                imageScale -= 1
                            }
                            if imageScale <= 1 {
                                imageScale = 1
                            }
                        }

                    } label: {
                        ControlImageView(iconName: "minus.magnifyingglass")
                    }

                    Button {
                        resetImageState()
                    } label: {
                        ControlImageView(iconName: "arrow.up.left.and.down.right.magnifyingglass")
                    }

                    Button {
                        withAnimation(.spring()) {
                            if imageScale < 5 {
                                imageScale += 1
                            }
                            if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                    } label: {
                        ControlImageView(iconName: "plus.magnifyingglass")
                    }
                }
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                .background(.ultraThinMaterial)
                .cornerRadius(12)

                .padding(.top, 30)
                , alignment: .bottom
            )
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
