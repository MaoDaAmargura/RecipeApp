//
//  ContentView.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AppHeaderView()
            RecipeListView(viewModel: RecipeListView.TestViewModel())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
