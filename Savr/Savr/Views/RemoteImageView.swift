//
//  RemoteImageView.swift
//  Savr
//
//  Created by Austin Kelley on 3/10/25.
//

import SwiftUI

struct RemoteImageView : View {
    
    var urlString:String?
    @ObservedObject var imageLoader = ImageLoader()
    @State var image = UIImage()
    
    var body: some View {
        Color(red: 0.9, green: 0.9, blue: 0.9)
            .overlay {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .background()
                    .onReceive(imageLoader.$image) { image in
                        Task { @MainActor in self.image = image }
                    }
                    .onAppear {
                        Task { await imageLoader.loadImage(for: urlString) }
                    }
            }
            .clipped()
    }
}

class ImageLoader : ObservableObject {
    
    @Published var image = UIImage()
    
    func loadImage(for urlString:String?) async {
        
        guard let urlString else { return }
        
        if let image = ImageCache.shared.image(for: urlString) {
            Task { @MainActor in self.image = image }
            return
        }
        
        guard
            let data = try? await Network.get(url: urlString),
            let image = UIImage(data: data)
        else {
            return
        }
        
        ImageCache.shared.save(image: image, for: urlString)
        Task { @MainActor in self.image = image }
    }
}
