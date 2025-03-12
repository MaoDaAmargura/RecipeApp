//
//  ImageCache.swift
//  Savr
//
//  Created by Austin Kelley on 3/10/25.
//

import Foundation
import UIKit

struct ImageCache {
    
    static let shared = ImageCache(cacheName: "imagecache.shared")
    
    let cacheName:String
    let documentUrl:URL?
    
    init(cacheName: String) {
        self.cacheName = cacheName
        self.documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: cacheName, directoryHint: .isDirectory)
        if let url = documentUrl {
            if !FileManager.default.fileExists(atPath: url.path()) {
                do {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                } catch {
                    
                }
            }
        }
        clear()
    }
    
    // quick hash of the path, maintaining the postfix,
    // to control length and uniqueness of the filename
    // while maintaining size information
    func filename(for url:String) -> String? {
        
        var imagePath = url
        var postfix = ""
        if url.lastIndex(of: "@") != nil {
            var comps = url.components(separatedBy: "@")
            postfix = "@" + comps.removeLast()
            imagePath = comps.joined(separator: "@")
        } else if url.lastIndex(of: ".") != nil {
            var comps = url.components(separatedBy: ".")
            postfix = "." + comps.removeLast()
            imagePath = comps.joined(separator: ".")
        }
        
        guard let data = imagePath.data(using: .utf8) else { return nil }
        let resultData = Crypto.SHA256(data: data)
        let result = Crypto.hexString(from: resultData) + postfix
        
        return result
    }
    
    func documentPath(for url:String) -> URL? {
        guard let documentUrl else { return nil }
        guard let filename = filename(for: url) else { return nil }
        return documentUrl.appendingPathComponent(filename)
    }
    
    func save(image:UIImage?, for url:String) {
        guard let filepath = documentPath(for: url) else { return }
        
        if let image {
            if let data = image.jpegData(compressionQuality: 1) {
                
                print("Image cached:", url, filename(for: url)!)
                try? data.write(to: filepath)
            }
        } else {
            try? FileManager.default.removeItem(at: filepath)
        }
    }
    
    func image(for url:String) -> UIImage? {
        guard let filepath = documentPath(for: url) else { return nil }
        return UIImage(contentsOfFile: filepath.path())
    }
    
    func clear(timeIntervalSinceNow:TimeInterval = 0) {
        
        guard let documentUrl else { return }
        
        let resourceKeys = Set<URLResourceKey>([.nameKey, .contentAccessDateKey])
        let enumerator = FileManager.default.enumerator(at: documentUrl, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)!
        
        for case let fileUrl as URL in enumerator {
            
            guard
                let resourceValues = try? fileUrl.resourceValues(forKeys: resourceKeys),
                let lastAccess = resourceValues.contentAccessDate
            else {
                continue
            }
            
            if timeIntervalSinceNow >= 0 || lastAccess.timeIntervalSinceNow < timeIntervalSinceNow {
                try? FileManager.default.removeItem(at: fileUrl)
            }
        }
    }
}
