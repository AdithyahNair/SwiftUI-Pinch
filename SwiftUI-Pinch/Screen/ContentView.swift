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
    @State private var isDrawerOpen: Bool = false

    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1

    // MARK: - Function

    func loadImage(pageIndex: Int) -> String {
        return pages[pageIndex - 1].imageName
    }

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

                Image(loadImage(pageIndex: pageIndex))
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

            // MARK: - Drawer Interface

            .overlay(
                HStack(spacing: 12) {
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }

                    ForEach(pages) { page in
                        Image(page.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                            .cornerRadius(4)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                withAnimation(.easeOut) {
                                    pageIndex = page.id
                                }
                            }
                    }

                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: UIScreen.main.bounds.width / 1.4)
                .cornerRadius(12)
                .offset(x: isDrawerOpen ? 20 : 240)
                .padding(.top, UIScreen.main.bounds.height / 10)
                , alignment: .topTrailing
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
