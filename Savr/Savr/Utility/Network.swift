//
//  Network.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

import Foundation

class Network {
    
    // Simple function to check for HTTP success codes
    class func isHTTPSuccess(_ httpCode:Int) -> Bool {
        switch httpCode {
        case 200..<300:
            return true
        default:
            return false
        }
    }
    
    // Async HTTP Get that returns the response as Data
    class func get(url urlStr:String?) async throws -> Data {
        
        guard let urlStr, let url = URL(string: urlStr) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard
            let httpResponse = response as? HTTPURLResponse,
            isHTTPSuccess(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
                
        return data
    }
    
    // Wrapper around Async HTTP Get that returns the response as a Decodable JSON object
    class func getJson<D : Decodable>(url urlStr:String?) async throws -> D {
        
        let data = try await get(url: urlStr)
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(D.self, from: data)
    }
}
