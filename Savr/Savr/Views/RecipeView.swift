//
//  RecipeView.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

import SwiftUI

struct RecipeView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                RemoteImageView(urlString: viewModel.imageUrlString)
                
                Text(viewModel.title ?? "")
                    .font(.system(size: 12, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .foregroundStyle(.orange)
                    .frame(height: 40)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .truncationMode(.tail)
                    
            }
            .background(Color(red: 1, green: 0.9, blue: 0.8))
            .clipShape(.rect(cornerRadius: 15))
            
            Text(viewModel.category ?? "")
                .font(.system(size: 12, weight: .regular))
                .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                .foregroundStyle(.orange)
                .background(.white)
                .clipShape(.rect(cornerRadius: 12))
                .offset(x: -8, y: 8)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

extension RecipeView {
    
    class ViewModel : ObservableObject, Identifiable {
        
        @Published var title:String?
        @Published var category:String?
        @Published var identifier:String?
        @Published var imageUrlString:String?
        
        init() {
            
        }
        
        init(_ model:RecipeModel) {
            self.title = model.name
            self.category = model.cuisine
            self.identifier = model.id
            self.imageUrlString = model.photoUrlSmall
        }
    }
    
    class TestViewModel : ViewModel {
        
        override init() {
            super.init()
            title = "Recipe Title"
            category = "Category"
            identifier = UUID().uuidString
            imageUrlString = "https://testimages.org/img/testimages_screenshot.jpg"
        }
        
    }
}

#Preview {
    RecipeView(viewModel: RecipeView.TestViewModel())
        .frame(width: 150, height: 200)
}
