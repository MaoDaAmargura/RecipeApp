//
//  AppHeaderView.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        HStack {
            Image("img_shiba_cooking")
            VStack(alignment: .leading) {
                Text("Hello, Chef!")
                    .font(.title)
                    .foregroundStyle(.orange)
                Text("What's cooking?")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AppHeaderView()
    Spacer()
}
