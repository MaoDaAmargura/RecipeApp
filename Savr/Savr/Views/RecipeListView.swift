//
//  RecipeListView.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject var viewModel = ViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { geometry in
            let width = floor((geometry.size.width - 64)/3) // 2 * 16 spacing and 2 * 16 padding
            let height = floor(width * 170 / 110)
            ScrollView(.vertical, showsIndicators: false) {
                if viewModel.recipes.count <= 0 {
                    EmptyListView()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) { // spacing
                        ForEach(viewModel.recipes) {
                            RecipeView(viewModel: $0)
                                .frame(width: width, height: height)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16)) // padding
            .refreshable {
                await viewModel.loadResults()
            }
            .onAppear {
                Task {
                    await viewModel.loadResults()
                }
            }
        }
    }
}

extension RecipeListView {
    
    class ViewModel : ObservableObject {
        
        @Published var recipes = [RecipeView.ViewModel]()
        
        func loadResults() async {
            
            do {
                let recipeResponse:RecipeNetworkResponse = try await Network.getJson(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
                let recipeVMs = recipeResponse.recipes.compactMap { RecipeView.ViewModel($0) }
                Task { @MainActor in self.recipes = recipeVMs }
                print("Recipes loaded")
            } catch let error as URLError where error.code == .cancelled {
                print("Recipes load cancelled")
            } catch let error as DecodingError {
                Task { @MainActor in self.recipes = [] }
                print("Recipes load failed - Invalid JSON", error)
            } catch {
                print("Recipes load failed - Other Issue", error)
            }
        }
    }
    
    class TestViewModel : ViewModel {
        
        override init() {
            super.init()
            
            recipes = [
                RecipeView.TestViewModel(),
                RecipeView.TestViewModel(),
                RecipeView.TestViewModel(),
                RecipeView.TestViewModel(),
                RecipeView.TestViewModel(),
                RecipeView.TestViewModel()
            ]
        }
    }
}

#Preview {
    RecipeListView(viewModel: RecipeListView.TestViewModel())
}
