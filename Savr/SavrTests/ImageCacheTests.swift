//
//  ImageCacheTests.swift
//  Savr
//
//  Created by Austin Kelley on 3/10/25.
//

import UIKit
import Testing
@testable import Savr

// These tests use the same image cache, and the same image URL
// If they run as a suite in parallel, they delete each others data
// So this suite is configured to run serially
@Suite(.serialized) class ImageCacheTests {

    let testImageCache = ImageCache(cacheName: "imagecache.tests")
    let testImageUrl = "https://someimagehosting.com/domain/coolimage@3x.jpg"
    let testImageUrl2 = "https://someimagehosting.com/domain/coolimage2@3x.jpg"
    
    init() {
        testImageCache.clear()
    }
    
    deinit {
        testImageCache.clear()
    }
    
    @Test func TestImageCacheAddFirstItem() async throws {
        
        let image = UIImage(named: "img_shiba_cooking")
        
        testImageCache.save(image: image, for: testImageUrl)
        
        let cachedImage = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage != nil)
        
        testImageCache.clear()
        
        let cachedImage2 = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage2 == nil)
    }

    @Test func TestImageCacheClearOld() async throws {
        
        let image = UIImage(named: "img_shiba_cooking")
        
        testImageCache.save(image: image, for: testImageUrl)
        
        let cachedImage = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage != nil)
        
        sleep(3)
        
        testImageCache.clear(timeIntervalSinceNow: -1)
        
        let cachedImage2 = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage2 == nil)
    }
    
    @Test func TestImageCacheClearNew() async throws {
        
        let image = UIImage(named: "img_shiba_cooking")
        
        testImageCache.save(image: image, for: testImageUrl)
        
        let cachedImage = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage != nil)
        
        sleep(3)
        
        testImageCache.clear(timeIntervalSinceNow: -5)
        
        let cachedImage2 = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage2 != nil)
    }
    
    @Test func TestImageCacheSetNil() async throws {
        
        let image = UIImage(named: "img_shiba_cooking")
        
        testImageCache.save(image: image, for: testImageUrl)
        
        let cachedImage = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage != nil)
        
        testImageCache.save(image: nil, for: testImageUrl)
        
        let cachedImage2 = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage2 == nil)
    }
    
    // This test also caught an issue where the images were saved to disk
    // and read back without scale information because I wasn't maintaining
    // the postfix (@2x.jpg) of the filename after hashing it
    // but you cant use UIImage == UIImage because the one created from (named:)
    // has a filename, but the one created from disk doesn't. 
    @Test func TestImageCacheSaveTwoAndDontOverlap() async throws {
        
        let image = UIImage(named: "img_shiba_cooking")
        let image2 = UIImage(named: "image_chefs_hat")
        
        testImageCache.save(image: image, for: testImageUrl)
        testImageCache.save(image: image2, for: testImageUrl2)
        
        let cachedImage = testImageCache.image(for: testImageUrl)
        
        #expect(cachedImage?.size == image?.size)
        #expect(cachedImage?.scale == image?.scale)
        
        let cachedImage2 = testImageCache.image(for: testImageUrl2)
        
        #expect(cachedImage2?.size == image2?.size)
        #expect(cachedImage2?.scale == image2?.scale)
    }
}
