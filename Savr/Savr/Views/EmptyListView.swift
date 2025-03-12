//
//  EmptyListView.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

import SwiftUI

struct EmptyListView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image("img_shiba_cooking")
                .resizable()
                .frame(width: 100, height: 100)
            Text("No Recipes Found")
                .font(.title2)
                .foregroundStyle(.orange)
            Text("Try us again later and hopefully we'll have more!")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 200)
        }
        
    }
}

#Preview {
    EmptyListView()
}
