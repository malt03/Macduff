//
//  Image.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest

extension XCTestCase {
    func getData(forResource: String, withExtension: String) -> Data {
        let url = Bundle(for: type(of: self)).url(forResource: forResource, withExtension: withExtension)!
        return try! Data(contentsOf: url)
    }
    
    #if os(macOS)
    func getImage(resourceName: String) -> NSImage {
        
    }
    #else
    func getImage(resourceName: String) -> UIImage {
        UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: resourceName, ofType: "png")!)!
    }
    
    func createRawData(from image: UIImage) -> [UInt8] {
        let data = image.cgImage!.dataProvider!.data
        let length = CFDataGetLength(data)
        var rawData = [UInt8](repeating: 0, count: length)
        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
        return rawData
    }
    #endif
}
