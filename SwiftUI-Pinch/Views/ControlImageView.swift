//
//  ControlImageView.swift
//  SwiftUI-Pinch
//
//  Created by Adithyah Nair on 28/11/22.
//

import SwiftUI

struct ControlImageView: View {
    // MARK: - Constants

    let iconName: String
    
    //MARK: - Body

    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: 30))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(iconName: "minus.magnifyingglass")
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
