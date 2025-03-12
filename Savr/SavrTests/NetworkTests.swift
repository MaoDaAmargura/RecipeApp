//
//  NetworkTests.swift
//  Savr
//
//  Created by Austin Kelley on 3/10/25.
//

import Foundation
import UIKit
import Testing
@testable import Savr

struct NetworkTests {

    @Test func TestNetworkSuccess() async throws {
        
        do {
            let data:Data = try await Network.get(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            #expect(data.count > 0) 
        } catch {
            assert(false)
        }
    }
    
    @Test func TestNetworkImageDownload() async throws {
        
        do {
            let data:Data = try await Network.get(url: "https://testimages.org/img/testimages_screenshot.jpg")
            let image = UIImage(data: data)
            #expect(image != nil)
        } catch {
            assert(false)
        }
    }
    
    @Test func TestNetworkJSONFetch() async throws {
        
        do {
            let response:RecipeNetworkResponse = try await Network.getJson(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            #expect(response.recipes.count > 0) // the valid endpoint should return recipes
        } catch {
            assert(false)
        }
    }

    @Test func TestNetworkMalformed() async throws {
        
        do {
            let _:RecipeNetworkResponse = try await Network.getJson(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
            #expect(Bool(false)) // we should not hit this if the JSON is malformed, it should throw an error
        } catch {
            print(error) // this should be an error
        }
    }
    
    @Test func TestNetworkEmpty() async throws {
        
        do {
            let response:RecipeNetworkResponse = try await Network.getJson(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
            #expect(response.recipes.count == 0)
        } catch {
            #expect(Bool(false))
        }
    }
}
