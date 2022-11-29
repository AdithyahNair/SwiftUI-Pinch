//
//  InfoPanelView.swift
//  SwiftUI-Pinch
//
//  Created by Adithyah Nair on 26/11/22.
//

import SwiftUI

struct InfoPanelView: View {
    //MARK: - Properties
    
    var scale: CGFloat
    var offset: CGSize
    
    @State private var isInfoPanelVisible: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "circle.circle")
                .resizable()
                .frame(width: 30,
                       height: 30)
                .symbolRenderingMode(.hierarchical)
                .onLongPressGesture(minimumDuration: 0.5) {
                    isInfoPanelVisible.toggle()
                }
            
            Spacer()
   
            HStack(spacing: 2) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                
                Spacer()
                
                Image(systemName: "arrow.left.arrow.right")
                Text("\(offset.width)")
                
                Spacer()
                
                Image(systemName: "arrow.up.arrow.down")
                Text("\(offset.height)")
            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisible ? 1 : 0)
            .animation(.easeOut(duration: 1), value: isInfoPanelVisible)
            
            Spacer()
        }
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
