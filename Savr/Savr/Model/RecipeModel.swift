//
//  RecipeModel.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

struct RecipeNetworkResponse : Codable {
    
    let recipes:[RecipeModel]
    
    enum CodingKeys: String, CodingKey {
        case recipes
    }
}

struct RecipeModel : Codable, Identifiable {
    
    let id: String
    let name: String
    let cuisine: String
    
    let photoUrlLarge:String?
    let photoUrlSmall:String?
    let sourceUrl:String?
    let youtubeUrl:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
