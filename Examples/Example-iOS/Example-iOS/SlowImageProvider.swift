//
//  SlowImageProvider.swift
//  Example-iOS
//
//  Created by Koji Murata on 2019/09/06.
//  Copyright © 2019 Koji Murata. All rights reserved.
//

import UIKit
import Macduff

struct SlowImageProvider: ImageProvider {
    let cacheKey = UUID().uuidString
    
    private static let image = #imageLiteral(resourceName: "lena")
    
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
//        for i in 0..<10 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i) / 5) {
//                progress(Float(i) / 10)
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            success(ProvidingImage(image: SlowImageProvider.image, originalData: SlowImageProvider.image.pngData()!))
//        }
    }
}

struct SlowLena: Source {
    var provider: ImageProvider { SlowImageProvider() }
}
